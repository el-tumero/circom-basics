pragma circom 2.0.0;

include "node_modules/circomlib/circuits/poseidon.circom";
include "node_modules/circomlib/circuits/bitify.circom";
include "node_modules/circomlib/circuits/sha256/sha256.circom";


//       *root hash
// *hash(0x0) *hash(0x0)

// 0x1406e05881e299367766d313e26c05564ec91bf721d31726bd6e46e60689539a // root hash

// 0x5feceb66ffc86f38d952786c6d696c79c2dbc239dd4e91b46729d73a27fb57e9 // hash zera

// template PerformSnapshot() {
//     signal input leafCount;
//     signal input inputLeafs;
//     signal input prevRoot;

//     signal output root;
    
// }

// v -> v .. .. ..

// function ComputeTree() {

// }


// template Hash() {
//     signal input in;
//     signal output out;

//     component bits = Num2Bits(256);
//     component num = Bits2Num(256);
//     component hasher = Sha256(256);

//     bits.in <== in;
//     for (var i = 0; i < 256; i++) {
//         hasher.in[i] <== bits.out[i];
//     }

//     for (var i = 0; i < 256; i++) {
//         num.in[i] <== hasher.out[i];
//     }

//     out <== num.out;
// }

template Hash() {
    signal input in;
    signal output out;

    component hasher = Poseidon(1);
    hasher.inputs[0] <== in;
    out <== hasher.out;
}





// template ExtendTree() {

// }

// // n is current tree leaves length
// template ExtendTree() {
//     component hashers[3];

//     signal input n;
//     signal output out;

//     var zeroVal[32] = [110, 52, 11, 156, 255, 179, 122, 152, 156, 165, 68, 230, 187, 120, 10, 44, 120, 144, 29, 63, 179, 55, 56, 118, 133, 17, 163, 6, 23, 175, 160, 29];

//     for(var i = 0; i < n; i++) {
//         hashers[i] = HashLeftRight();
//         hashers[i].left <== zeroVal;
//         hashers[i].right <== zeroVal;
//     }

//     hashers[2] = HashLeftRight();
//     hashers[2].left <== hashers[0].out;
//     hashers[2].right <== hashers[1].out;

//     out <== hashers[2].out;
// }


component main = Hash();

// function EditLeaf() {

// }
