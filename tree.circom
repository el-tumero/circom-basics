pragma circom 2.0.0;

include "node_modules/circomlib/circuits/poseidon.circom";
include "node_modules/circomlib/circuits/bitify.circom";
include "node_modules/circomlib/circuits/sha256/sha256.circom";


//       *root hash
// *hash(0x0) *hash(0x0)

// 0x1406e05881e299367766d313e26c05564ec91bf721d31726bd6e46e60689539a // root hash

// 0x5feceb66ffc86f38d952786c6d696c79c2dbc239dd4e91b46729d73a27fb57e9 // hash zera



template HashLeftRight() {
    signal input left;
    signal input right;
    signal output hash;

    component hasher = Poseidon(2);

    hasher.inputs[0] <== left;
    hasher.inputs[1] <== right;
    hash <== hasher.out;
}

template MerkleTreeConstructor() {
    signal input data[4];
    signal output root;
    signal output branches[2];
    signal output hashedLeaves[4];
    
    component hashers[3];
    component leafHashers[4];

    for(var i = 0; i < 4; i++) {
        leafHashers[i] = Poseidon(1);
        leafHashers[i].inputs[0] <== data[i];
        hashedLeaves[i] <== leafHashers[i].out;
    }

    for(var i = 0; i < 2; i++) {
        hashers[i] = HashLeftRight();
        hashers[i].left <== leafHashers[i*2].out;
        hashers[i].right <== leafHashers[(i*2)+1].out;
        branches[i] <== hashers[i].out;
    }
    
    hashers[2] = HashLeftRight();
    hashers[2].left <== branches[0];
    hashers[2].right <== branches[1];

    root <== hashers[2].out;
}

// source: https://github.com/tornadocash/tornado-core/blob/master/circuits/merkleTree.circom

// if s == 0 returns [in[0], in[1]]
// if s == 1 returns [in[1], in[0]]
template DualMux() {
    signal input in[2];
    signal input s;
    signal output out[2];

    s * (1 - s) === 0;
    out[0] <== (in[1] - in[0])*s + in[0];
    out[1] <== (in[0] - in[1])*s + in[1];
}

// Verifies that merkle proof is correct for given merkle root and a leaf
// pathIndices input is an array of 0/1 selectors telling whether given pathElement is on the left or right side of merkle path
template MerkleTreeChecker(levels) {
    signal input leafData;
    signal input root;
    signal input pathElements[levels];
    signal input pathIndices[levels];

    component leaf = Poseidon(1);
    leaf.inputs[0] <== leafData;

    signal output out;

    component selectors[levels];
    component hashers[levels];

    for (var i = 0; i < levels; i++) {
        selectors[i] = DualMux();
        selectors[i].in[0] <== i == 0 ? leaf.out : hashers[i - 1].hash;
        selectors[i].in[1] <== pathElements[i];
        selectors[i].s <== pathIndices[i];

        hashers[i] = HashLeftRight();
        hashers[i].left <== selectors[i].out[0];
        hashers[i].right <== selectors[i].out[1];
    }
    
    out <== hashers[levels - 1].hash;
}


component main = MerkleTreeChecker(2);


