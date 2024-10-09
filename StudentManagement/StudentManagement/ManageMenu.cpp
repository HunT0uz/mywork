#include "ManageMenu.h"
#include"User.h"
#include<iostream>
#include"Person.h"
#include<conio.h>
#include<sstream>
#include<fstream>
#include <algorithm>
#include<time.h>
#include<iomanip>
using namespace std;
void ManageMenu::Initialization(const string& Username,const string& rname)
{
	realname = rname;
	string folder = "User.AddressBook";
	folderName = folder + "/" + Username;
	folderCelebrate = folderName + "/" + "Celebrate";
	string File_Path;
	File_Path = folderName + "/" + "AddressBook1.txt";
	readData<Student>(File_Path);
	File_Path = folderName + "/" + "AddressBook2.txt";
	readData<Colleague>(File_Path);
	File_Path = folderName + "/" + "AddressBook3.txt";
	readData<Friend>(File_Path);
	File_Path = folderName + "/" + "AddressBook4.txt";
	readData<Relative>(File_Path);
}
void ManageMenu::create_Dir(const string& Username,const string &name)
{
	realname = name;
	string folder = "User.AddressBook";
	folderName =folder+"/"+Username;
	folderCelebrate = folderName + "/" + "Celebrate";
	if (!fs::is_directory(folderName))
	{
		fs::create_directory(folderName);	
	}
	if (!fs::is_directory(folderCelebrate))
	{
		fs::create_directory(folderCelebrate);
	}
	Save();
}
void ManageMenu::Save()
{
	string File_Path;
	File_Path = folderName + "/" + "AddressBook1.txt";
	writeData<Student>(File_Path);
	File_Path = folderName + "/" + "AddressBook2.txt";
	writeData<Colleague>(File_Path);
	File_Path = folderName + "/" + "AddressBook3.txt";
	writeData<Friend>(File_Path);
	File_Path = folderName + "/" + "AddressBook4.txt";
	writeData<Relative>(File_Path);
}
void ManageMenu::Run()
{
	int op = Menu()-1;
	system("cls");
	switch (op)
	{
	case ManageMenu::Add1:
		Add(); Continue();
		break;
	case ManageMenu::Modify2:
		Modify(); Continue();
		break;
	case ManageMenu::Delete3:
		Delete(); Continue();
		break;
	case ManageMenu::Search4:
		Search(); Continue();
		break;
	case ManageMenu::Find5:
		Find(); Continue();
		break;
	case ManageMenu::Sort6:
		Sort(); Continue();
		break;
	case ManageMenu::Number7:
		Number(); Continue();
		break;
	case ManageMenu::Display8:
		Display1(); Continue();
		break;
	case ManageMenu::Display9:
		Display2(); Continue();
		break;
	case ManageMenu::Exit0:
		Exit();
		break;
	default:
		break;
	}
}
int ManageMenu::Menu()
{
	char c;
	{
		system("cls");
		std::cout << "�˵�:\n";
		std::cout << "1. �����ϵ��\n";
		std::cout << "2. �༭��ϵ��\n";
		std::cout << "3. ɾ����ϵ��\n";
		std::cout << "4. ��������ѯ��ϵ��\n";
		std::cout << "5. ����5���ڹ����յ���ϵ��\n";
		std::cout << "6. �������������������\n";
		std::cout << "7. ͳ�Ƹ����·ݳ���������\n";
		std::cout << "8. ��ʾ������ϵ����Ϣ\n";
		std::cout << "9. ������ʾ��ϵ����Ϣ\n";
		std::cout << "0. �˳�\n";
		std::cout << "����������ѡ��: ";
		c = _getch();
	}
	if (c - '0' < 0 || c - '0' > 9)
	{
		Menu();
	}
	return(c - '0');
}
void ManageMenu::Continue()
{
	Save();
	printf("��������������˵���");
	int choice;
	choice = _getch()-'0';
	if (choice != NULL)
		Run();
}
template<typename T>
void ManageMenu::AddHelper(string additional)
{
	string name, number, email, birth, extra;
	cout << "������"; cin >> name;
	cout << "���գ���ʽ��yyyymmdd����"; cin >> birth;
	while (!isBirthRight(birth))
	{
		cout << "���ո�ʽ�������������룡" << endl;
		cout << "���գ���ʽ��yyyymmdd����"; cin >> birth;
	}
	cout << "�绰��"; cin >> number;
	while (!isNumberRight(number))
	{
		cout << "�绰��ʽ�������������룡" << endl;
		cout << "�绰��"; cin >> number;
	}
	cout << "���䣺"; cin >> email;
	cout << additional; cin >> extra;
	vec_stu.push_back(new T(name, birth, number, email, extra));
}
bool ManageMenu::isNumberRight(string number)
{
	if (number.size() != 11)
	{
		return false;
	}
	for (int i = 0; i < number.size(); i++)
	{
		if (!isdigit(number[i]))
		{
			return false;
		}
	}
	return true;
}
bool ManageMenu::isBirthRight(string birth)
{
	if (birth.length() != 8 || !all_of(birth.begin(), birth.end(), ::isdigit))
		return false;
	int year = stoi(birth.substr(0, 4));
	int month = stoi(birth.substr(4, 2));
	int day = stoi(birth.substr(6, 2));
	if (year < 1900 || year > 2023)
		return false;
	if (month < 1 || month > 12)
		return false;
	int Right_day = 31;
	switch (month) 
	{
	case 4:case 6:case 9:case 11:
		Right_day = 30;
		break;
	case 2:
		Right_day = (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0) ? 29 : 28;
		break;
	}
	if (day < 1 || day > Right_day)
		return false;
	return true;
}
void ManageMenu::Add()
{
	char op;
	cout << "1.ͬѧ" << endl;
	cout << "2.ͬ��" << endl;
	cout << "3.����" << endl;
	cout << "4.����" << endl;
	cout << "ѡ��";
	op = _getch() - '0' - 1;
	cout << endl;
	switch (op)
	{
	case 0://ͬѧ
		AddHelper<Student>("ѧУ��");
		break;
	case 1://ͬ��
		AddHelper<Colleague>("��˾��");
		break;
	case 2://����
		AddHelper<Friend>("��ʶ�ص㣺");
		break;
	case 3://����
		AddHelper<Relative>("��ϵ��");
		break;
	default:
		break;
	}
	return;
}
void ManageMenu::Delete()
{
	string name;
	cout << "����Ҫɾ������ϵ������: ";
	cin >> name;
	vector<Person*> candidates;
	for (auto it = vec_stu.begin(); it != vec_stu.end(); it++)
	{
		if ((*it)->getname() == name)
		{
			candidates.push_back(*it);
		}
	}
	if (candidates.empty())
	{
		cout << "���޴��ˡ�~~" << endl;
		return;
	}
	if (candidates.size() == 1)
	{
		candidates[0]->display();
		delete candidates[0];
		vec_stu.erase(remove(vec_stu.begin(), vec_stu.end(), candidates[0]), vec_stu.end());
		cout << "ɾ���ɹ�~~~" << endl;
	}
	else
	{
		cout << "��ȷ��Ҫɾ������ϵ����Ϣ��" << endl;
		for (int i = 0; i < candidates.size(); i++)
		{
			cout << i + 1 << ". ";
			candidates[i]->display();
		}
		cout << "��ѡ��Ҫɾ������ϵ����ţ�����0ȡ������";
		int choice = 0;
		cin >> choice;
		if (choice == 0 )
		{
			cout << "ȡ��ɾ����" << endl;
		}
		else if (choice > candidates.size())
		{
			cout << "�����������Ч�����������롣" << endl;
			Delete();
			return;
		}
		else
		{
			candidates[choice - 1]->display();
			delete candidates[choice - 1];
			vec_stu.erase(std::remove(vec_stu.begin(), vec_stu.end(), candidates[choice - 1]), vec_stu.end());
			cout << "ɾ���ɹ�~~~" << endl;
		}
	}
	return;
}
void ManageMenu::Search()
{
	string name;
	cout << "��Ҫ���ҵ��˵�������";
	cin >> name;
	Person* person = nullptr;
	for (auto s : vec_stu)
	{
		if (s->getname() == name)
		{
			person = s;
			s->display();
		}
	}
	if (person != nullptr)
	{
		return;
	}
	else
	{
		cout << "���޴��ˡ�~~" << endl;
	}
	return;
}
void ManageMenu::Display1()
{
	for (Person* val : vec_stu)
	{
		val->display();
	}
	std::cout << "��(" << vec_stu.size() << ")������" << endl;
	return;
}
template<typename T>
void ManageMenu::displayContactsOfType()
{
	for (Person* p : vec_stu)
	{
		T* s = dynamic_cast<T*>(p);
		if (s)
		{
			s->display();
		}
	}
}
void ManageMenu::Display2()
{
	// ������ʾ��ϵ����Ϣ
	char op;
	cout << "1.ͬѧ" << endl;
	cout << "2.ͬ��" << endl;
	cout << "3.����" << endl;
	cout << "4.����" << endl;
	cout << "ѡ��";
	op = _getch() - '0' - 1;
	switch (op)
	{
	case 0:
		cout << "ͬѧ��Ϣ: " << endl;
		displayContactsOfType<Student>();
		break;
	case 1:
		cout << "ͬ����Ϣ��" << endl;
		displayContactsOfType<Colleague>();
		break;
	case 2:
		cout << "������Ϣ��" << endl;
		displayContactsOfType<Friend>();
		break;
	case 3:
		cout << "������Ϣ��" << endl;
		displayContactsOfType<Relative>();
		break;
	default:
		break;
	}
	return;
}
void ManageMenu::Find()
{
	int count = 0;
	time_t now = time(0);
	tm current_time;
	localtime_s(&current_time, &now);
	for (Person* p : vec_stu)
	{
		int birth_month = stoi(p->getbirth().substr(4, 2));
		int birth_day = stoi(p->getbirth().substr(6, 2));
		if (birth_month == current_time.tm_mon + 1 && birth_day - current_time.tm_mday >= 0 && birth_day - current_time.tm_mday <= 5)
		{
			count++;
			string wday[] = { "����", "��һ", "�ܶ�", "����", "����", "����", "����" };
			tm birth_time = { 0 };
			birth_time.tm_year = current_time.tm_year;
			birth_time.tm_mon = birth_month - 1;
			birth_time.tm_mday = birth_day;
			mktime(&birth_time);
			cout << birth_month << "��" << birth_day << "��" << "(" << wday[birth_time.tm_wday] << ")" << endl;
			p->display();
			string person = p->getname();
			stringstream ss;
			ss <<person << "." << count << ".txt";
			string filename = ss.str();
			ofstream out(folderCelebrate+"/"+filename);
			if (out)
			{
				out << "��ף����������" << p->getname() << endl;
				out << '\t' << "ף���տ��֣������Ҹ���" << endl;
				out << "                                     ף��������:" << realname << endl;
				cout << "����ף���ʼ������ɣ�" << endl;
			}
			else
			{
				cout << "�޷����ļ���" << endl;
			}
		}
	}
	return;
};
void ManageMenu::Modify()
{
	string name;
	cout << "����Ҫ�༭����ϵ������: ";
	cin >> name;
	vector<Person*>::iterator it;
	vector<Person*> candidates;
	for (it = vec_stu.begin(); it != vec_stu.end(); it++)
	{
		if ((*it)->getname() == name)
		{
			candidates.push_back(*it);
		}
	}
	if (candidates.empty())
	{
		cout << "���޴��ˡ�~~" << endl;
	}
	else if (candidates.size() == 1)
	{
		Person* p = candidates[0];
		p->display();
		cout << "�����µĵ绰: " << endl;
		string number, email, nature;
		cin >> number;
		while (!isNumberRight(number))
		{
			cout << "�绰��ʽ�������������룡" << endl;
			cout << "�绰��"; cin >> number;
		}
		cout << "�����µ����䣺" << endl;
		cin >> email;
		cout << "�����µ�" << p->getextra() << endl;
		cin >> nature;
		p->set(number, email, nature);
		cout << "�༭�ɹ���~~" << endl;
	}
	else
	{
		cout << "��ȷ��Ҫ�༭����ϵ����Ϣ(��0ȡ������" << endl;
		for (int i = 0; i < candidates.size(); i++)
		{
			cout << i + 1 << ". ";
			candidates[i]->display();
		}
		int choice;
		cin >> choice;
		if (choice == 0)
		{
			cout << "ȡ���༭��~" << endl;
		}
		else if (choice > candidates.size() || choice<0)
		{
			cout << "����������������롣" << endl;
			Modify();
		}
		Person* p = candidates[choice - 1];
		p->display();
		cout << "�����µĵ绰: " << endl;
		string number, email, nature;
		cin >> number;
		cout << "�����µ����䣺" << endl;
		cin >> email;
		cout << "�����µ�" << p->getextra() << endl;
		cin >> nature;
		p->set(number, email, nature);
		cout << "�༭�ɹ���~~" << endl;
	}
	return;
}
void ManageMenu::Number()
{
	while (true)
	{
		int month, count = 0;
		cout << "����Ҫͳ�Ƶ��·�: ";
		cin >> month;
		if (month > 0 && month < 13)
		{
			for (Person* p : vec_stu) {
				int birthMonth = stoi(p->getbirth().substr(4, 2));
				if (birthMonth == month)
				{
					p->display();
					++count;
				}
			}
			cout << "��" << month << "�·ݳ���������: " << count << endl;
			return;
		}
		else { cout << "�������" << endl; continue; }
	}
}
void ManageMenu::Sort()
{
	std::cout << "*** ѡ����������     ***" << endl;
	std::cout << "*** 1,����������     ***" << endl;
	std::cout << "*** 2,����������     ***" << endl;
	std::cout << "ѡ��";
	int choice;
	std::cin >> choice;
	if (choice == 1) {
		stable_sort(vec_stu.begin(), vec_stu.end(), [](Person* e1, Person* e2) { return e1->getname() < e2->getname(); });
		cout << "����ɹ�QaQ~" << endl;
	}
	else if (choice == 2) {
		stable_sort(vec_stu.begin(), vec_stu.end(), [](Person* e1, Person* e2) { return e1->getbirth() < e2->getbirth(); });
		cout << "����ɹ�QaQ~" << endl;
	}
	return;
}
void ManageMenu::Exit()
{
	Save();
	UserManager A;
	A.Run();
}
template <typename T>
void ManageMenu::readData(const std::string& fileName)
{
	std::ifstream instuf(fileName, std::ios::in);
	if (instuf.is_open())
	{
		std::string name, birth, number, email, extra;
		char buf[1024] = { 0 };
		while (instuf >> name >> birth >> number >> email >> extra)
		{
			memset(buf, 0, sizeof(buf));
			instuf.getline(buf, 1024);
			vec_stu.push_back(new T(name, birth, number, email, extra));
		}
		instuf.close();
		return;
	}
	else
	{
		std::cerr << fileName << " file open failed" << std::endl;
		return;
	}
}
template <typename T>
void ManageMenu::writeData(const std::string& fileName)
{
	std::string info;
	std::ofstream outstuf(fileName, std::ios::out);
	if (outstuf.is_open())
	{
		for (Person* val : vec_stu)
		{
			T* s = dynamic_cast<T*>(val);
			if (s)
			{
				outstuf << s->getname() << '\t' << s->getbirth()<< '\t' << s->getnumber() << '\t' << s->getemail() << '\t' << s->getnature() << std::endl;
				
				
			}
		}
		outstuf.close();
		return;
	}
	else
	{
		std::cerr << fileName << " file open failed" << std::endl;
		return;
	}
}