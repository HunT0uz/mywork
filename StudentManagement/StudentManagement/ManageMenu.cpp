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
		std::cout << "菜单:\n";
		std::cout << "1. 添加联系人\n";
		std::cout << "2. 编辑联系人\n";
		std::cout << "3. 删除联系人\n";
		std::cout << "4. 按姓名查询联系人\n";
		std::cout << "5. 查找5天内过生日的联系人\n";
		std::cout << "6. 按姓名或出生日期排序\n";
		std::cout << "7. 统计给定月份出生的人数\n";
		std::cout << "8. 显示所有联系人信息\n";
		std::cout << "9. 分类显示联系人信息\n";
		std::cout << "0. 退出\n";
		std::cout << "请输入您的选择: ";
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
	printf("按任意键返回主菜单。");
	int choice;
	choice = _getch()-'0';
	if (choice != NULL)
		Run();
}
template<typename T>
void ManageMenu::AddHelper(string additional)
{
	string name, number, email, birth, extra;
	cout << "姓名："; cin >> name;
	cout << "生日（格式：yyyymmdd）："; cin >> birth;
	while (!isBirthRight(birth))
	{
		cout << "生日格式错误，请重新输入！" << endl;
		cout << "生日（格式：yyyymmdd）："; cin >> birth;
	}
	cout << "电话："; cin >> number;
	while (!isNumberRight(number))
	{
		cout << "电话格式错误，请重新输入！" << endl;
		cout << "电话："; cin >> number;
	}
	cout << "邮箱："; cin >> email;
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
	cout << "1.同学" << endl;
	cout << "2.同事" << endl;
	cout << "3.朋友" << endl;
	cout << "4.亲戚" << endl;
	cout << "选择：";
	op = _getch() - '0' - 1;
	cout << endl;
	switch (op)
	{
	case 0://同学
		AddHelper<Student>("学校：");
		break;
	case 1://同事
		AddHelper<Colleague>("公司：");
		break;
	case 2://朋友
		AddHelper<Friend>("相识地点：");
		break;
	case 3://亲戚
		AddHelper<Relative>("关系：");
		break;
	default:
		break;
	}
	return;
}
void ManageMenu::Delete()
{
	string name;
	cout << "输入要删除的联系人姓名: ";
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
		cout << "查无此人。~~" << endl;
		return;
	}
	if (candidates.size() == 1)
	{
		candidates[0]->display();
		delete candidates[0];
		vec_stu.erase(remove(vec_stu.begin(), vec_stu.end(), candidates[0]), vec_stu.end());
		cout << "删除成功~~~" << endl;
	}
	else
	{
		cout << "请确认要删除的联系人信息：" << endl;
		for (int i = 0; i < candidates.size(); i++)
		{
			cout << i + 1 << ". ";
			candidates[i]->display();
		}
		cout << "请选择要删除的联系人序号（输入0取消）：";
		int choice = 0;
		cin >> choice;
		if (choice == 0 )
		{
			cout << "取消删除。" << endl;
		}
		else if (choice > candidates.size())
		{
			cout << "输入的数据无效，请重新输入。" << endl;
			Delete();
			return;
		}
		else
		{
			candidates[choice - 1]->display();
			delete candidates[choice - 1];
			vec_stu.erase(std::remove(vec_stu.begin(), vec_stu.end(), candidates[choice - 1]), vec_stu.end());
			cout << "删除成功~~~" << endl;
		}
	}
	return;
}
void ManageMenu::Search()
{
	string name;
	cout << "你要查找的人的姓名：";
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
		cout << "查无此人。~~" << endl;
	}
	return;
}
void ManageMenu::Display1()
{
	for (Person* val : vec_stu)
	{
		val->display();
	}
	std::cout << "共(" << vec_stu.size() << ")条数据" << endl;
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
	// 分类显示联系人信息
	char op;
	cout << "1.同学" << endl;
	cout << "2.同事" << endl;
	cout << "3.朋友" << endl;
	cout << "4.亲戚" << endl;
	cout << "选择：";
	op = _getch() - '0' - 1;
	switch (op)
	{
	case 0:
		cout << "同学信息: " << endl;
		displayContactsOfType<Student>();
		break;
	case 1:
		cout << "同事信息：" << endl;
		displayContactsOfType<Colleague>();
		break;
	case 2:
		cout << "朋友信息：" << endl;
		displayContactsOfType<Friend>();
		break;
	case 3:
		cout << "亲戚信息：" << endl;
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
			string wday[] = { "周日", "周一", "周二", "周三", "周四", "周五", "周六" };
			tm birth_time = { 0 };
			birth_time.tm_year = current_time.tm_year;
			birth_time.tm_mon = birth_month - 1;
			birth_time.tm_mday = birth_day;
			mktime(&birth_time);
			cout << birth_month << "月" << birth_day << "日" << "(" << wday[birth_time.tm_wday] << ")" << endl;
			p->display();
			string person = p->getname();
			stringstream ss;
			ss <<person << "." << count << ".txt";
			string filename = ss.str();
			ofstream out(folderCelebrate+"/"+filename);
			if (out)
			{
				out << "被祝贺人姓名：" << p->getname() << endl;
				out << '\t' << "祝生日快乐，健康幸福。" << endl;
				out << "                                     祝贺人姓名:" << realname << endl;
				cout << "生日祝福邮件已生成！" << endl;
			}
			else
			{
				cout << "无法打开文件！" << endl;
			}
		}
	}
	return;
};
void ManageMenu::Modify()
{
	string name;
	cout << "输入要编辑的联系人姓名: ";
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
		cout << "查无此人。~~" << endl;
	}
	else if (candidates.size() == 1)
	{
		Person* p = candidates[0];
		p->display();
		cout << "输入新的电话: " << endl;
		string number, email, nature;
		cin >> number;
		while (!isNumberRight(number))
		{
			cout << "电话格式错误，请重新输入！" << endl;
			cout << "电话："; cin >> number;
		}
		cout << "输入新的邮箱：" << endl;
		cin >> email;
		cout << "输入新的" << p->getextra() << endl;
		cin >> nature;
		p->set(number, email, nature);
		cout << "编辑成功！~~" << endl;
	}
	else
	{
		cout << "请确认要编辑的联系人信息(按0取消）：" << endl;
		for (int i = 0; i < candidates.size(); i++)
		{
			cout << i + 1 << ". ";
			candidates[i]->display();
		}
		int choice;
		cin >> choice;
		if (choice == 0)
		{
			cout << "取消编辑。~" << endl;
		}
		else if (choice > candidates.size() || choice<0)
		{
			cout << "输入错误，请重新输入。" << endl;
			Modify();
		}
		Person* p = candidates[choice - 1];
		p->display();
		cout << "输入新的电话: " << endl;
		string number, email, nature;
		cin >> number;
		cout << "输入新的邮箱：" << endl;
		cin >> email;
		cout << "输入新的" << p->getextra() << endl;
		cin >> nature;
		p->set(number, email, nature);
		cout << "编辑成功！~~" << endl;
	}
	return;
}
void ManageMenu::Number()
{
	while (true)
	{
		int month, count = 0;
		cout << "输入要统计的月份: ";
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
			cout << "在" << month << "月份出生的人数: " << count << endl;
			return;
		}
		else { cout << "输入错误！" << endl; continue; }
	}
}
void ManageMenu::Sort()
{
	std::cout << "*** 选择排序属性     ***" << endl;
	std::cout << "*** 1,按姓名排序     ***" << endl;
	std::cout << "*** 2,按生日排序     ***" << endl;
	std::cout << "选择：";
	int choice;
	std::cin >> choice;
	if (choice == 1) {
		stable_sort(vec_stu.begin(), vec_stu.end(), [](Person* e1, Person* e2) { return e1->getname() < e2->getname(); });
		cout << "排序成功QaQ~" << endl;
	}
	else if (choice == 2) {
		stable_sort(vec_stu.begin(), vec_stu.end(), [](Person* e1, Person* e2) { return e1->getbirth() < e2->getbirth(); });
		cout << "排序成功QaQ~" << endl;
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