#pragma once
#include <string>
#include<iostream>
using namespace std;
class Person
{
public:
    Person(string n, string b, string p, string e) : name(n), birth(b), number(p), email(e) {}//¼����Ϣ
    virtual void display() {
        cout << "����: " << name << ", ��������: " << birth << ", �绰: " << number << ", ����: " << email <<", " << extra << nature << endl;
    };
    string getname() { return name; }
    string getbirth() { return birth; }
    string getnumber() { return number; }
    string getemail() { return email; }
    string getnature() { return nature; }
    string getextra() { return extra; }
    void set(string new_number, string new_email, string new_nature) { number = new_number; email = new_email; nature = new_nature; }
protected:
	string number;//�绰����
	string email;//�ʼ�
	string name;//����
	string birth;//����
    string nature;//����
    string extra;
};
class Student : public Person {
public:
    Student(string n, string b, string p, string e, string s) : Person(n, b, p, e) { nature = s; extra = "ѧУ��"; }
};

class Colleague : public Person {
public:
    Colleague(string n, string b, string p, string e, string c) : Person(n, b, p, e) { nature = c; extra = "��˾��"; }
};

class Friend : public Person {
public:
    Friend(string n, string b, string p, string e, string l) : Person(n, b, p, e) { nature = l; extra = "��ʶ�ص㣺"; }
};

class Relative : public Person {
public:
    Relative(string n, string b, string p, string e, string r) : Person(n, b, p, e) { nature = r; extra = "��ϵ��"; }
};