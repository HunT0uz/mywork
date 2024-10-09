/********************************************************************************
** Form generated from reading UI file 'gamewidget.ui'
**
** Created by: Qt User Interface Compiler version 5.12.12
**
** WARNING! All changes made in this file will be lost when recompiling UI file!
********************************************************************************/

#ifndef UI_GAMEWIDGET_H
#define UI_GAMEWIDGET_H

#include <QtCore/QVariant>
#include <QtWidgets/QApplication>
#include <QtWidgets/QLCDNumber>
#include <QtWidgets/QLabel>
#include <QtWidgets/QPushButton>
#include <QtWidgets/QVBoxLayout>
#include <QtWidgets/QWidget>

QT_BEGIN_NAMESPACE

class Ui_gamewidget
{
public:
    QWidget *layoutWidget_2;
    QVBoxLayout *verticalLayout_2;
    QLabel *label_2;
    QLCDNumber *lcd_black;
    QLabel *lb_black_position;
    QWidget *layoutWidget;
    QVBoxLayout *verticalLayout;
    QLabel *label;
    QLCDNumber *lcd_write;
    QLabel *lb_white_position;
    QWidget *verticalLayoutWidget;
    QVBoxLayout *verticalLayout_3;
    QPushButton *btn_restart;
    QPushButton *btn_return;
    QPushButton *btn_prompt;
    QPushButton *btn_regret;
    QPushButton *btn_reverse;
    QWidget *verticalLayoutWidget_2;
    QVBoxLayout *verticalLayout_4;
    QLabel *lb_eval;
    QLabel *label_3;
    QLabel *lb_timeuse;

    void setupUi(QWidget *gamewidget)
    {
        if (gamewidget->objectName().isEmpty())
            gamewidget->setObjectName(QString::fromUtf8("gamewidget"));
        gamewidget->resize(876, 646);
        gamewidget->setStyleSheet(QString::fromUtf8(""));
        layoutWidget_2 = new QWidget(gamewidget);
        layoutWidget_2->setObjectName(QString::fromUtf8("layoutWidget_2"));
        layoutWidget_2->setGeometry(QRect(750, 150, 111, 141));
        verticalLayout_2 = new QVBoxLayout(layoutWidget_2);
        verticalLayout_2->setObjectName(QString::fromUtf8("verticalLayout_2"));
        verticalLayout_2->setContentsMargins(0, 0, 0, 0);
        label_2 = new QLabel(layoutWidget_2);
        label_2->setObjectName(QString::fromUtf8("label_2"));

        verticalLayout_2->addWidget(label_2);

        lcd_black = new QLCDNumber(layoutWidget_2);
        lcd_black->setObjectName(QString::fromUtf8("lcd_black"));

        verticalLayout_2->addWidget(lcd_black);

        lb_black_position = new QLabel(layoutWidget_2);
        lb_black_position->setObjectName(QString::fromUtf8("lb_black_position"));

        verticalLayout_2->addWidget(lb_black_position);

        layoutWidget = new QWidget(gamewidget);
        layoutWidget->setObjectName(QString::fromUtf8("layoutWidget"));
        layoutWidget->setGeometry(QRect(750, 10, 111, 141));
        verticalLayout = new QVBoxLayout(layoutWidget);
        verticalLayout->setObjectName(QString::fromUtf8("verticalLayout"));
        verticalLayout->setContentsMargins(0, 0, 0, 0);
        label = new QLabel(layoutWidget);
        label->setObjectName(QString::fromUtf8("label"));

        verticalLayout->addWidget(label);

        lcd_write = new QLCDNumber(layoutWidget);
        lcd_write->setObjectName(QString::fromUtf8("lcd_write"));
        lcd_write->setEnabled(true);
        lcd_write->setMinimumSize(QSize(89, 0));

        verticalLayout->addWidget(lcd_write);

        lb_white_position = new QLabel(layoutWidget);
        lb_white_position->setObjectName(QString::fromUtf8("lb_white_position"));

        verticalLayout->addWidget(lb_white_position);

        verticalLayoutWidget = new QWidget(gamewidget);
        verticalLayoutWidget->setObjectName(QString::fromUtf8("verticalLayoutWidget"));
        verticalLayoutWidget->setGeometry(QRect(629, 300, 241, 170));
        verticalLayout_3 = new QVBoxLayout(verticalLayoutWidget);
        verticalLayout_3->setObjectName(QString::fromUtf8("verticalLayout_3"));
        verticalLayout_3->setContentsMargins(0, 0, 0, 0);
        btn_restart = new QPushButton(verticalLayoutWidget);
        btn_restart->setObjectName(QString::fromUtf8("btn_restart"));
        btn_restart->setStyleSheet(QString::fromUtf8("background-image: url(;/E:/DesktopData/data structure/Bigwork/tingyun.ico);"));

        verticalLayout_3->addWidget(btn_restart);

        btn_return = new QPushButton(verticalLayoutWidget);
        btn_return->setObjectName(QString::fromUtf8("btn_return"));

        verticalLayout_3->addWidget(btn_return);

        btn_prompt = new QPushButton(verticalLayoutWidget);
        btn_prompt->setObjectName(QString::fromUtf8("btn_prompt"));
        btn_prompt->setStyleSheet(QString::fromUtf8("background-image: url(;/E:/DesktopData/data structure/Bigwork/tingyun.ico);"));

        verticalLayout_3->addWidget(btn_prompt);

        btn_regret = new QPushButton(verticalLayoutWidget);
        btn_regret->setObjectName(QString::fromUtf8("btn_regret"));

        verticalLayout_3->addWidget(btn_regret);

        btn_reverse = new QPushButton(verticalLayoutWidget);
        btn_reverse->setObjectName(QString::fromUtf8("btn_reverse"));

        verticalLayout_3->addWidget(btn_reverse);

        verticalLayoutWidget_2 = new QWidget(gamewidget);
        verticalLayoutWidget_2->setObjectName(QString::fromUtf8("verticalLayoutWidget_2"));
        verticalLayoutWidget_2->setGeometry(QRect(630, 480, 241, 141));
        verticalLayout_4 = new QVBoxLayout(verticalLayoutWidget_2);
        verticalLayout_4->setObjectName(QString::fromUtf8("verticalLayout_4"));
        verticalLayout_4->setContentsMargins(0, 0, 0, 0);
        lb_eval = new QLabel(verticalLayoutWidget_2);
        lb_eval->setObjectName(QString::fromUtf8("lb_eval"));

        verticalLayout_4->addWidget(lb_eval);

        label_3 = new QLabel(verticalLayoutWidget_2);
        label_3->setObjectName(QString::fromUtf8("label_3"));

        verticalLayout_4->addWidget(label_3);

        lb_timeuse = new QLabel(verticalLayoutWidget_2);
        lb_timeuse->setObjectName(QString::fromUtf8("lb_timeuse"));

        verticalLayout_4->addWidget(lb_timeuse);


        retranslateUi(gamewidget);

        QMetaObject::connectSlotsByName(gamewidget);
    } // setupUi

    void retranslateUi(QWidget *gamewidget)
    {
        gamewidget->setWindowTitle(QApplication::translate("gamewidget", "Form", nullptr));
        label_2->setText(QApplication::translate("gamewidget", " \351\273\221\346\243\213 ", nullptr));
        lb_black_position->setText(QString());
        label->setText(QApplication::translate("gamewidget", " \347\231\275\346\243\213", nullptr));
        lb_white_position->setText(QString());
        btn_restart->setText(QApplication::translate("gamewidget", "\351\207\215\346\226\260\345\274\200\345\247\213", nullptr));
        btn_return->setText(QApplication::translate("gamewidget", "\350\277\224\345\233\236", nullptr));
        btn_prompt->setText(QApplication::translate("gamewidget", "\346\217\220\347\244\272", nullptr));
        btn_regret->setText(QApplication::translate("gamewidget", "\346\202\224\346\243\213", nullptr));
        btn_reverse->setText(QApplication::translate("gamewidget", "\345\217\215\350\275\254", nullptr));
        lb_eval->setText(QApplication::translate("gamewidget", "ai\345\261\200\351\235\242\344\274\260\345\210\206:", nullptr));
        label_3->setText(QApplication::translate("gamewidget", "\346\217\220\347\244\272\344\275\215\347\275\256\357\274\232", nullptr));
        lb_timeuse->setText(QApplication::translate("gamewidget", "ai\350\256\241\347\256\227\350\200\227\346\227\266:", nullptr));
    } // retranslateUi

};

namespace Ui {
    class gamewidget: public Ui_gamewidget {};
} // namespace Ui

QT_END_NAMESPACE

#endif // UI_GAMEWIDGET_H
