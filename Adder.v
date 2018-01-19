/**
 * 超前进位加法器
 */

/**
 * @brief 2位超前进位
 */
module CLA2(
    input  [1:0] iG,
    input  [1:0] iP,
    input  iC,
    output oG,
    output oP,
    output [2:0] oC
);

    assign oC[0] = iC;
    assign oC[1] = iG[0] | (iP[0] & oC[0]);

    assign oG = iG[1] | (iP[1] & iG[0]);    // 进位产生信号
    assign oP = iP[1] & iP[0];              // 进位传递信号

    assign oC[2] = oG | (oP & oC[0]);

endmodule

/**
 * @brief 4位超前进位
 */
module CLA4(
    input  [3:0] iG,
    input  [3:0] iP,
    input  iC,
    output oG,
    output oP,
    output [4:0] oC
);

    assign oC[0] = iC;
    assign oC[1] = iG[0] | (iP[0] & oC[0]);
    assign oC[2] = iG[1] | (iP[1] & iG[0]) | (iP[1] & iP[0] & oC[0]);
    assign oC[3] = iG[2] | (iP[2] & iG[1]) | (iP[2] & iP[1] & iG[0]) | (iP[2] & iP[1] & iP[0] & oC[0]);

    assign oG = iG[3] | (iP[3] & iG[2]) | (iP[3] & iP[2] & iG[1]) | (iP[3] & iP[2] & iP[1] & iG[0]);
    assign oP = iP[3] & iP[2] & iP[1] & iP[0];

    assign oC[4] = oG | (oP & oC[0]);

endmodule

/**
 * @brief 4位超前进位加法器
 */
module Adder4(
    input  [3:0] iA,
    input  [3:0] iB,
    input  iC,
    output [3:0] oS,
    output oG,
    output oP,
    output oC
);
    wire [3:0] G = iA & iB;     // 进位产生信号
    wire [3:0] P = iA | iB;     // 进位传递信号
    wire [3:0] C;

    CLA4 cla(.iG(G), .iP(P), .iC(iC), .oG(oG), .oP(oP), .oC({oC, C}));

    assign oS = iA ^ iB ^ C;

endmodule

/**
 * @brief 8位超前进位加法器
 */
module Adder8(
    input  [7:0] iA,
    input  [7:0] iB,
    input  iC,
    output [7:0] oS,
    output oG,
    output oP,
    output oC
);

    wire [1:0] G;
    wire [1:0] P;
    wire [1:0] C;

    Adder4 adder0(.iA(iA[3:0]), .iB(iB[3:0]), .iC(C[0]), .oS(oS[3:0]), .oG(G[0]), .oP(P[0]));
    Adder4 adder1(.iA(iA[7:4]), .iB(iB[7:4]), .iC(C[1]), .oS(oS[7:4]), .oG(G[1]), .oP(P[1]));

    CLA2 cla(.iG(G), .iP(P), .iC(iC), .oG(oG), .oP(oP), .oC({oC, C}));

endmodule

/**
 * @brief 16位超前进位加法器
 */
module Adder16(
    input  [15:0] iA,
    input  [15:0] iB,
    input  iC,
    output [15:0] oS,
    output oG,
    output oP,
    output oC
);

    wire [3:0] G;
    wire [3:0] P;
    wire [3:0] C;

    Adder4 adder0(.iA(iA[ 3: 0]), .iB(iB[ 3: 0]), .iC(C[0]), .oS(oS[ 3: 0]), .oG(G[0]), .oP(P[0]));
    Adder4 adder1(.iA(iA[ 7: 4]), .iB(iB[ 7: 4]), .iC(C[1]), .oS(oS[ 7: 4]), .oG(G[1]), .oP(P[1]));
    Adder4 adder2(.iA(iA[11: 8]), .iB(iB[11: 8]), .iC(C[2]), .oS(oS[11: 8]), .oG(G[2]), .oP(P[2]));
    Adder4 adder3(.iA(iA[15:12]), .iB(iB[15:12]), .iC(C[3]), .oS(oS[15:12]), .oG(G[3]), .oP(P[3]));

    CLA4 cla(.iG(G), .iP(P), .iC(iC), .oG(oG), .oP(oP), .oC({oC, C}));

endmodule

/**
 * @brief 32位超前进位加法器
 */
module Adder32(
    input  [31:0] iA,
    input  [31:0] iB,
    input  iC,
    output [31:0] oS,
    output oG,
    output oP,
    output oC
);

    wire [1:0] G;
    wire [1:0] P;
    wire [1:0] C;

    Adder16 adder0(.iA(iA[15: 0]), .iB(iB[15: 0]), .iC(C[0]), .oS(oS[15: 0]), .oG(G[0]), .oP(P[0]));
    Adder16 adder1(.iA(iA[31:16]), .iB(iB[31:16]), .iC(C[1]), .oS(oS[31:16]), .oG(G[1]), .oP(P[1]));

    CLA2 cla(.iG(G), .iP(P), .iC(iC), .oG(oG), .oP(oP), .oC({oC, C}));

endmodule

/**
 * @brief 64位超前进位加法器
 */
module Adder64(
    input  [63:0] iA,
    input  [63:0] iB,
    input  iC,
    output [63:0] oS,
    output oG,
    output oP,
    output oC
);

    wire [3:0] G;
    wire [3:0] P;
    wire [3:0] C;

    Adder16 adder0(.iA(iA[15: 0]), .iB(iB[15: 0]), .iC(C[0]), .oS(oS[15: 0]), .oG(G[0]), .oP(P[0]));
    Adder16 adder1(.iA(iA[31:16]), .iB(iB[31:16]), .iC(C[1]), .oS(oS[31:16]), .oG(G[1]), .oP(P[1]));
    Adder16 adder2(.iA(iA[47:32]), .iB(iB[47:32]), .iC(C[2]), .oS(oS[47:32]), .oG(G[2]), .oP(P[2]));
    Adder16 adder3(.iA(iA[63:48]), .iB(iB[63:48]), .iC(C[3]), .oS(oS[63:48]), .oG(G[3]), .oP(P[3]));

    CLA4 cla(.iG(G), .iP(P), .iC(iC), .oG(oG), .oP(oP), .oC({oC, C}));

endmodule
