#pragma once
#include <string>
#include<iostream>
using namespace std;
class Person
{
public:
    Person(string n, string b, string p, string e) : name(n), birth(b), number(p), email(e) {}//录入信息
    virtual void display() {
        cout << "姓名: " << name << ", 出生日期: " << birth << ", 电话: " << number << ", 邮箱: " << email <<", " << extra << nature << endl;
    };
    string getname() { return name; }
    string getbirth() { return birth; }
    string getnumber() { return number; }
    string getemail() { return email; }
    string getnature() { return nature; }
    string getextra() { return extra; }
    void set(string new_number, string new_email, string new_nature) { number = new_number; email = new_email; nature = new_nature; }
protected:
	string number;//电话号码
	string email;//邮件
	string name;//姓名
	string birth;//生日
    string nature;//属性
    string extra;
};
class Student : public Person {
public:
    Student(string n, string b, string p, string e, string s) : Person(n, b, p, e) { nature = s; extra = "学校："; }
};

class Colleague : public Person {
public:
    Colleague(string n, string b, string p, string e, string c) : Person(n, b, p, e) { nature = c; extra = "公司："; }
};

class Friend : public Person {
public:
    Friend(string n, string b, string p, string e, string l) : Person(n, b, p, e) { nature = l; extra = "相识地点："; }
};

class Relative : public Person {
public:
    Relative(string n, string b, string p, string e, string r) : Person(n, b, p, e) { nature = r; extra = "关系："; }
};