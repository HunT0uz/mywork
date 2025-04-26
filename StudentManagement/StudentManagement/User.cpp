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
    // ���ļ��ж�ȡ�û��б�
    LoadFromFile("data/userList.txt");
}

void UserManager::Run()
{
    system("cls");
    cout << "|ѧ��ͨѶ¼����ϵͳ|\n";
    cout << "��ѡ��(��0�˳�����\n";
    cout << "1.��¼\n";
    cout << "2.ע��\n";
    char op;
    op = _getch()-'0';
    if (op > 2 || op < 0)
    {
        cerr << "������Ч��������ѡ��~" << endl;
        printf("��������������˵���");
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
        cout << "����������û�����" << endl;
        cin >> Username;
        cout << "������������룺" << endl;
        cin >> code;
        if (Login(Username, code))
        {
            printf("��������������˵���");
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
            printf("��������������˵���");
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
        cout << "����������û�����" << endl;
        cin >> new_Username;
        cout << "������������룺" << endl;
        cin >> new_code;
        cout << "���������������" << endl;
        cin >> name;
        if (RegisterUser(new_Username, new_code,name))
        {
            printf("��������������˵���");
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
            printf("��������������˵���");
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
    // �ж��û����Ƿ��Ѵ���
    if (userMap.find(username) != userMap.end())
    {
        cerr << "Username already exists!" << endl;
        return false;
    }

    // �������û�
    UserInfo newUser;
    newUser.username = username;
    newUser.password = password;
    newUser.name = realName;

    // ������û����û��б�
    userMap.insert(make_pair(username, newUser));
    cout << "User registered successfully!" << endl;
    SaveToFile("data/userList.txt");
    return true;
}

// �û���¼
bool UserManager::Login(const string& username, const string& password)
{
    // �����û�
    auto it = userMap.find(username);
    if (it == userMap.end())
    {
        cerr << "Username does not exist!" << endl;
        return false;
    }

    // ��֤����
    if (it->second.password != password)
    {
        cerr << "Incorrect password!" << endl;
        return false;
    }
    rname = it->second.name;
    cout << "Login successful!" << endl;
    return true;
}

// �����û��б��ļ�
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

// ���ļ��ж�ȡ�û��б�
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