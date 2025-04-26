#pragma once
#include <iostream>
#include <string>
#include <map>
#include <fstream>
#include <filesystem>
using namespace std;
namespace fs = std::filesystem;
// 用户信息结构体
struct UserInfo
{
    string username;
    string password;
    string name;
};
// 用户管理类
class UserManager
{
public:
    UserManager();
    void Run();
    // 注册新用户
    bool RegisterUser(const string& username, const string& password,const string& name);
    // 用户登录
    bool Login(const string& username, const string& password);
    // 保存用户列表到文件
    bool SaveToFile(const string& fileName);
    // 从文件中读取用户列表
    bool LoadFromFile(const string& fileName);
private:
    map<string, UserInfo> userMap; // 用户列表
    string rname;
};