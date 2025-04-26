#pragma once
#include<vector>
#include"Person.h"
using namespace std;
class ManageMenu
{
	std::string realname;
	std::string folderName;
	std::string folderCelebrate;
	std::string tableHeader;	//��ͷ
	std::vector<Person*> vec_stu;//����
	enum Operator
	{
		Add1, Modify2, Delete3, Search4, Find5, Sort6, Number7, Display8,Display9,Exit0
	};
public:
	ManageMenu() {};
	~ManageMenu() { Save(); }
	void Initialization(const string& Username,const string& rname);
	void create_Dir(const string& Username,const string& name);
	void Run();//�����˵����档
	template<typename T>
	void AddHelper(string additional);
	bool isNumberRight(string number);
	bool isBirthRight(string birth);
	void Add();//¼����Ϣ��
	void Modify();//�޸���Ϣ��
	void Delete();//ɾ����Ϣ��
	void Search();//��ѯ��
	void Find();//�������ա�
	void Sort();//����
	void Number();//ͳ�Ƹ����·�������
	template<typename T>
	void displayContactsOfType();//�б�鿴��Ϣ��
	void Display1();
	void Display2();
	int Menu();//Menu
	void Continue();
	void Save();//Save
	void Exit();//Exit;
	template<typename T> void readData(const std::string& fileName);//read
	template<typename T> void writeData(const std::string& fileName);//write
};