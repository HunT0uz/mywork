#ifndef WIDGET_H
#define WIDGET_H

#include <QWidget>
#include "gamewidget.h"

namespace Ui {
    class widget;
}

class Widget : public QWidget
{
    Q_OBJECT

public:
    Widget(QWidget *parent = nullptr);
    ~Widget();

private slots:
    void playerButtonPush();
    void aiButtonPush();

private:
    Ui::widget *ui;
    gameWidget *game;
};
#endif // WIDGET_H
