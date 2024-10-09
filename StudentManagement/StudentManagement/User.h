#pragma once
#include <iostream>
#include <string>
#include <map>
#include <fstream>
#include <filesystem>
using namespace std;
namespace fs = std::filesystem;
// �û���Ϣ�ṹ��
struct UserInfo
{
    string username;
    string password;
    string name;
};
// �û�������
class UserManager
{
public:
    UserManager();
    void Run();
    // ע�����û�
    bool RegisterUser(const string& username, const string& password,const string& name);
    // �û���¼
    bool Login(const string& username, const string& password);
    // �����û��б��ļ�
    bool SaveToFile(const string& fileName);
    // ���ļ��ж�ȡ�û��б�
    bool LoadFromFile(const string& fileName);
private:
    map<string, UserInfo> userMap; // �û��б�
    string rname;
};