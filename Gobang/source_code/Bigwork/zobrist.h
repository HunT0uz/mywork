#ifndef ZOBRIST_H
#define ZOBRIST_H

#include<iostream>
#include<vector>
#include<random>
#include<QDebug>
#include<QPoint>

#define C_NONE 0
#define C_BLACK 1
#define C_WHITE 2

class HashEntry{
public:
    unsigned long long hashkey;
    int depth;
    int score;
    int flag;
    int couWorth;
    int worth[15][15];
};

class zobrist{
private:
    std::vector<HashEntry> table;//置换表
public:
    zobrist(unsigned long long size);
    zobrist();
    void store(unsigned long long hashkey, int depth, int score, int flag);
    bool probe(unsigned long long hashkey, int depth, int& score, int& flag);
    void initRandomTable();
    unsigned long long calculateHash(int board[][15]);

};

#endif // ZOBRIST_H
