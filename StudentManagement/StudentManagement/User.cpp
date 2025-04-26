#include "User.h"
#include<iostream>
#include<string>
#include<map>
#include<filesystem>
#include<conio.h>
#include "ManageMenu.h"
using namespace std;
namespace fs = std::filesystem;
UserManager::UserManager()
{
    // 从文件中读取用户列表
    LoadFromFile("data/userList.txt");
}

void UserManager::Run()
{
    system("cls");
    cout << "|学生通讯录管理系统|\n";
    cout << "请选择(按0退出）：\n";
    cout << "1.登录\n";
    cout << "2.注册\n";
    char op;
    op = _getch()-'0';
    if (op > 2 || op < 0)
    {
        cerr << "输入无效，请重新选择~" << endl;
        printf("按任意键返回主菜单。");
        int choice;
        choice = _getch() - '0';
        if (choice != NULL)
        {
            Run();
        }
        return;
    }
    switch (op)
    {
    case 0:
        exit(0);
        break;
    case 1:
    {
        string Username; string code;
        cout << "请输入你的用户名：" << endl;
        cin >> Username;
        cout << "请输入你的密码：" << endl;
        cin >> code;
        if (Login(Username, code))
        {
            printf("按任意键返回主菜单。");
            int choice;
            choice = _getch() - '0';
            if (choice != NULL)
            {
                ManageMenu A;
                A.Initialization(Username,rname);
                A.Run();
                A.Exit();
            }
        }
        else
        {
            printf("按任意键返回主菜单。");
            int choice;
            choice = _getch() - '0';
            if (choice != NULL)
            {
                Run();
            }
        }
        break; 
    }
    case 2:
    {
        string new_Username; string new_code; string name;
        cout << "请输入你的用户名：" << endl;
        cin >> new_Username;
        cout << "请输入你的密码：" << endl;
        cin >> new_code;
        cout << "请输入你的姓名：" << endl;
        cin >> name;
        if (RegisterUser(new_Username, new_code,name))
        {
            printf("按任意键返回主菜单。");
            int choice;
            choice = _getch() - '0';
            if (choice != NULL)
            {
                ManageMenu A;
                A.create_Dir(new_Username,name);
                A.Run();
                A.Exit();
            }
        }
        else
        {
            printf("按任意键返回主菜单。");
            int choice;
            choice = _getch() - '0';
            if (choice != NULL)
            {
                Run();
            }
        }
        break;
    }
    }
}
bool UserManager::RegisterUser(const string& username, const string& password,const string& realName)
{
    // 判断用户名是否已存在
    if (userMap.find(username) != userMap.end())
    {
        cerr << "Username already exists!" << endl;
        return false;
    }

    // 创建新用户
    UserInfo newUser;
    newUser.username = username;
    newUser.password = password;
    newUser.name = realName;

    // 添加新用户到用户列表
    userMap.insert(make_pair(username, newUser));
    cout << "User registered successfully!" << endl;
    SaveToFile("data/userList.txt");
    return true;
}

// 用户登录
bool UserManager::Login(const string& username, const string& password)
{
    // 查找用户
    auto it = userMap.find(username);
    if (it == userMap.end())
    {
        cerr << "Username does not exist!" << endl;
        return false;
    }

    // 验证密码
    if (it->second.password != password)
    {
        cerr << "Incorrect password!" << endl;
        return false;
    }
    rname = it->second.name;
    cout << "Login successful!" << endl;
    return true;
}

// 保存用户列表到文件
bool UserManager::SaveToFile(const string& fileName)
{
    ofstream outFile(fileName);
    if (outFile.is_open())
    {
        for (auto& [username, userInfo] : userMap)
        {
            outFile << username << " " << userInfo.password << " " << userInfo.name << endl;
        }
        outFile.close();
        return true;
    }
    else
    {
        cerr << "Failed to save file!" << endl;
        return false;
    }
}

// 从文件中读取用户列表
bool UserManager::LoadFromFile(const string& fileName)
{
    ifstream inFile(fileName);
    if (inFile.is_open())
    {
        string username, password, name;
        while (inFile >> username >> password >> name)
        {
            UserInfo userInfo;
            userInfo.username = username;
            userInfo.password = password;
            userInfo.name = name;
            userMap.insert(make_pair(username, userInfo));
        }
        inFile.close();
        return true;
    }
    else
    {
        cerr << "Failed to load file!" << endl;
        return false;
    }
}