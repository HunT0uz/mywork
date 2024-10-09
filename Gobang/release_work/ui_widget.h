/********************************************************************************
** Form generated from reading UI file 'widget.ui'
**
** Created by: Qt User Interface Compiler version 5.12.12
**
** WARNING! All changes made in this file will be lost when recompiling UI file!
********************************************************************************/

#ifndef UI_WIDGET_H
#define UI_WIDGET_H

#include <QtCore/QVariant>
#include <QtWidgets/QApplication>
#include <QtWidgets/QPushButton>
#include <QtWidgets/QTextBrowser>
#include <QtWidgets/QWidget>

QT_BEGIN_NAMESPACE

class Ui_widget
{
public:
    QPushButton *btn_ai;
    QPushButton *btn_player;
    QTextBrowser *textBrowser;

    void setupUi(QWidget *widget)
    {
        if (widget->objectName().isEmpty())
            widget->setObjectName(QString::fromUtf8("widget"));
        widget->resize(706, 465);
        btn_ai = new QPushButton(widget);
        btn_ai->setObjectName(QString::fromUtf8("btn_ai"));
        btn_ai->setGeometry(QRect(150, 280, 93, 71));
        btn_player = new QPushButton(widget);
        btn_player->setObjectName(QString::fromUtf8("btn_player"));
        btn_player->setGeometry(QRect(480, 280, 93, 71));
        textBrowser = new QTextBrowser(widget);
        textBrowser->setObjectName(QString::fromUtf8("textBrowser"));
        textBrowser->setGeometry(QRect(220, 70, 301, 61));

        retranslateUi(widget);

        QMetaObject::connectSlotsByName(widget);
    } // setupUi

    void retranslateUi(QWidget *widget)
    {
        widget->setWindowTitle(QApplication::translate("widget", "Form", nullptr));
        btn_ai->setText(QApplication::translate("widget", "ai\346\250\241\345\274\217", nullptr));
        btn_player->setText(QApplication::translate("widget", "\347\216\251\345\256\266\346\250\241\345\274\217", nullptr));
        textBrowser->setHtml(QApplication::translate("widget", "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.0//EN\" \"http://www.w3.org/TR/REC-html40/strict.dtd\">\n"
"<html><head><meta name=\"qrichtext\" content=\"1\" /><style type=\"text/css\">\n"
"p, li { white-space: pre-wrap; }\n"
"</style></head><body style=\" font-family:'SimSun'; font-size:9pt; font-weight:400; font-style:normal;\">\n"
"<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\"><span style=\" font-size:16pt; font-weight:600;\">\344\272\224\345\255\220\346\243\213\357\274\210\346\227\240\347\246\201\346\211\213\357\274\211</span></p></body></html>", nullptr));
    } // retranslateUi

};

namespace Ui {
    class widget: public Ui_widget {};
} // namespace Ui

QT_END_NAMESPACE

#endif // UI_WIDGET_H
