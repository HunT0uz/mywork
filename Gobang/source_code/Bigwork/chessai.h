#ifndef CHESSAI_H
#define CHESSAI_H

#include<QDebug>
#include<QPoint>
#include<QMap>
#include"zobrist.h"

#define EXACT 4
#define ALPHA 1
#define BETA 2
#define KILL 3

#define C_NONE 0
#define C_BLACK 1
#define C_WHITE 2

#define RIGHT 0
#define UP 1
#define UPRIGHT 2
#define UPLEFT 3

//各棋形代号以及分数设定
#define OTHER 0
#define WIN 1
#define LOSE 2
#define FLEX4 3
#define flex4 4
#define BLOCK4 5
#define block4 6
#define FLEX3 7
#define flex3 8
#define BLOCK3 9
#define block3 10
#define FLEX2 11
#define flex2 12
#define BLOCK2 13
#define block2 14
#define FLEX1 15
#define flex1 16

enum gameMode{PLAYER,AI,NONE};
enum gameStatus{UNDERWAY,FINISH};
enum gameTurn{T_BLACK,T_WHITE};
enum gameResult{R_BLACK,R_WHITE,R_DRAW};

struct EVALUATION{
    int score;
    gameResult result;
    int STAT[8];//不同棋形的数量
};

struct POINTS{
    QPoint pos[20];
    int score[20];
};

struct DECISION{
    QPoint pos;
    int eval;
};

class chessAi{
public:
    int chess_board [15][15];
    DECISION decision;
    int myChess[15][15];
    zobrist zobb = zobrist((unsigned long long)100000);

public:
    chessAi();
    int tupleScoreGreedy(int black,int white,int C_ME);
    int calcOnePosGreedy(int board[15][15],int row,int cal,int C_ME);
    QPoint getXY(int row,int col,int dir,int rel);
    bool checkBound(int x,int y);
    QPoint findPossPosGreedy(int C_ME);

public:
    void init_tupletype();
    POINTS seekPoints(int board[15][15],int flag,int depth);
    void copyBoard(int A_board[15][15],int B_board[15][15]);
    void reverseBoard(int A_board[15][15],int B_board[15][15]);
    EVALUATION evaluate(int board[15][15]);
    int analyse(int board[15][15],int depth,int alpha,int beta);

    bool analyse_kill(int board[15][15],int depth);
    QList<QPoint> seek_kill_points(int board[15][15],int depth);

private:
    int tupletype [4][4][4][4][4][4];
    POINTS best_pos;
};

#endif // CHESSAI_H
