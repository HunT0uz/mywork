#pragma once
#include<vector>
#include"Person.h"
using namespace std;
class ManageMenu
{
	std::string realname;
	std::string folderName;
	std::string folderCelebrate;
	std::string tableHeader;	//表头
	std::vector<Person*> vec_stu;//数组
	enum Operator
	{
		Add1, Modify2, Delete3, Search4, Find5, Sort6, Number7, Display8,Display9,Exit0
	};
public:
	ManageMenu() {};
	~ManageMenu() { Save(); }
	void Initialization(const string& Username,const string& rname);
	void create_Dir(const string& Username,const string& name);
	void Run();//打开主菜单界面。
	template<typename T>
	void AddHelper(string additional);
	bool isNumberRight(string number);
	bool isBirthRight(string birth);
	void Add();//录入信息。
	void Modify();//修改信息。
	void Delete();//删除信息。
	void Search();//查询。
	void Find();//查找生日。
	void Sort();//排序。
	void Number();//统计给定月份人数。
	template<typename T>
	void displayContactsOfType();//列表查看信息。
	void Display1();
	void Display2();
	int Menu();//Menu
	void Continue();
	void Save();//Save
	void Exit();//Exit;
	template<typename T> void readData(const std::string& fileName);//read
	template<typename T> void writeData(const std::string& fileName);//write
};