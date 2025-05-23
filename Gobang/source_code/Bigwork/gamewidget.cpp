#include "gamewidget.h"
#include "ui_gamewidget.h"
//构造函数，初始化parent指针和ui对象

gameWidget::gameWidget(QWidget *parent) :QWidget(parent),ui(new Ui::gamewidget){
    //把ui添加到该页面中
    ui->setupUi(this);
    for(int i=0;i<15;++i){//棋盘左上角点为(35,30),每格间距为40
        for(int j=0;j<15;++j){
            chessboard[i][j].setX(35+40*i);
            chessboard[i][j].setY(30+40*j);
        }
    }
    this->setWindowTitle("五子棋游戏界面");
    //使用方法：connect(sender, signal, receiver, slot);
    connect(this->ui->btn_return,SIGNAL(clicked(bool)),this,SLOT(returnPush()));
    connect(this->ui->btn_restart,SIGNAL(clicked(bool)),this,SLOT(initializeGame1()));
    connect(this->ui->btn_regret,SIGNAL(clicked(bool)),this,SLOT(regret()));
    connect(this->ui->btn_prompt,SIGNAL(clicked(bool)),this,SLOT(prompt()));
    connect(this->ui->btn_reverse,SIGNAL(clicked(bool)),this,SLOT(reverse()));
    setMouseTracking(true);//不用点击鼠标也一直追踪
    initializeGame();

}
gameWidget::~gameWidget()
{
    delete ui;
}
//悔棋函数
void gameWidget::regret(){
    qDebug()<<"regret";
    if(numOfChess<=0){
        initializeGame1();
        return;
    }
    this->hide();
    exRegret();
    update();
    this->show();
    update();
}
//悔棋实现函数
void gameWidget::exRegret(){
    int col1,col2,row1,row2;
    if(mode==AI){
    //遍历棋谱，找到最后两个下的子，仍是玩家走棋
        for(int row=0;row<15;row++){
            for(int col=0;col<15;col++){
                if(usedChesses[row][col]==numOfChess){
                    row1=row;
                    col1=col;
                    //务必在删除棋子后清空棋谱，不然会导致漏删棋子
                    usedChesses[row][col]=0;
                }
                if(usedChesses[row][col]==numOfChess-1){
                    row2=row;
                    col2=col;
                    usedChesses[row][col]=0;
                }
                if(usedChesses[row][col]==numOfChess-2){
                    lastRow=row;
                    lastCol=col;
                }
            }
        }
        ai.chess_board[row1][col1]=C_NONE;
        ai.chess_board[row2][col2]=C_NONE;
        numOfChess-=2;
        if(numOfChess<=0){
            initializeGame1();
        }
    }
    //玩家模式只需要一步悔棋
    else if(mode==PLAYER){
        for(int row=0;row<15;row++){
            for(int col=0;col<15;col++){
                if(usedChesses[row][col]==numOfChess){
                    row1=row;
                    col1=col;
                    usedChesses[row][col]=0;
                }
                if(usedChesses[row][col]==numOfChess-1){
                    lastRow=row;
                    lastCol=col;
                }
            }
        }
        //删除最后一颗子
        ai.chess_board[row1][col1]=C_NONE;
        if(turn==T_WHITE) turn=T_BLACK;
        else turn=T_WHITE;
        numOfChess--;
    }
    status=UNDERWAY;

}

void gameWidget::returnPush(){
    emit returnSignal();
    qDebug()<<"return";
    this->hide();
    initializeGame();
}

void gameWidget::initializeGame1(){

    qDebug()<<"start";
    this->hide();
    initializeGame();
    this->show();
}
void gameWidget::initializeGame(){

    int static count=0;
    qDebug()<<"游戏第"<<count<<"次初始化";
    if(mode==PLAYER)qDebug()<<"上一次游玩的是玩家模式";
    else if(mode==AI) qDebug()<<"上一次游玩的是人机模式";
    else if(mode==NONE) qDebug()<<"无模式";
    ai.zobb.initRandomTable();

    for(int i=0;i<15;++i){
        for(int j=0;j<15;++j){
            ai.chess_board[i][j]=C_NONE;
            usedChesses[i][j]=0;
        }
    }

    status=UNDERWAY;
    turn=T_BLACK;
    cursorRow=-1;
    cursorCol=-1;
    count++;
    numOfChess=0;
}

void gameWidget::paintEvent(QPaintEvent *event){

    QPainter painter(this);
    painter.setRenderHint(QPainter::Antialiasing);
    //画棋盘
    painter.setPen(Qt::black);
    for(int i=0;i<15;++i){
        painter.drawLine(chessboard[0][i],chessboard[14][i]);
        painter.drawLine(chessboard[i][0],chessboard[i][14]);
    }
    if(turn==T_BLACK)painter.setBrush(Qt::black);
    else painter.setBrush(Qt::white);
    //画鼠标光标
    if(cursorRow!=-1&&cursorCol!=-1){
        //8为光标边长
        QRect rec(chessboard[cursorCol][cursorRow].x()-12/2,chessboard[cursorCol][cursorRow].y()-12/2,12,12);
        painter.drawRect(rec);
    }
    //画棋子
    for(int i=0;i<15;++i){
        for(int j=0;j<15;++j){
            if(ai.chess_board[i][j]!=C_NONE&&ai.myChess[i][j]!=0){
                if(ai.chess_board[i][j]==C_BLACK||ai.myChess[i][j]%2==1){
                    painter.setBrush(Qt::black);
                    ai.chess_board[i][j]=C_BLACK;

                }
                else {painter.setBrush(Qt::white);
                    ai.chess_board[i][j]=C_WHITE;
                }

                //判断是否为最后一颗棋子
                //是棋子会按顺序遍历，从0，0到14，14.如果在前面的棋子是last one
                //那么画笔的颜色就会被改成红色，于是接下来每一个给棋子描边的画笔都是红色
                //只需要在标记the last one之后把红色改回即可
                if (i == lastRow && j == lastCol) {
                    painter.drawEllipse(chessboard[j][i].x()-30/2, chessboard[j][i].y()-30/2, 30, 30);
                    painter.setPen(QPen(Qt::red, 4, Qt::SolidLine)); // 设置画笔
                    painter.drawLine(chessboard[j][i].x() - 10, chessboard[j][i].y(), chessboard[j][i].x() + 10, chessboard[j][i].y());
                    painter.drawLine(chessboard[j][i].x(), chessboard[j][i].y() - 10, chessboard[j][i].x(), chessboard[j][i].y() + 10);
                    //把画笔调回默认情况下的黑色
                    painter.setPen(QPen(Qt::black));
                } else {
                    painter.drawEllipse(chessboard[j][i].x()-30/2, chessboard[j][i].y()-30/2, 30, 30);
                }
            }
        }
    }
    // 画提示位置
    if(hintRow != -1 && hintCol != -1) {
        paintHintPosition(painter, hintRow, hintCol);
    }
}

void gameWidget::paintHintPosition(QPainter &painter, int row, int col)
{
    painter.setPen(Qt::blue);
    painter.setBrush(Qt::NoBrush);
    painter.drawRect(chessboard[col][row].x() - 15, chessboard[col][row].y() - 15, 30, 30);
}

void gameWidget::mouseMoveEvent(QMouseEvent *event){
    //判断鼠标是否在棋盘内
    if(event->x()>=0&&event->x()<=610&&event->y()>=15&&event->y()<=605){//15=30-15,605=30+14*40+15
        //如果在棋盘内，则把鼠标设置为空白
        setCursor(Qt::BlankCursor);
        for(int i=0;i<15;++i)
            for(int j=0;j<15;++j){
                //鼠标位置
                float x=event->x(),y=event->y();
                //判断鼠标落在哪一个点附近(正方形范围)
                if((x>=(chessboard[i][j].x()-15))&&(x<(chessboard[i][j].x()+15))&&
                   (y>=(chessboard[i][j].y()-15))&&(y<(chessboard[i][j].y()+15))){
                    cursorRow=j;
                    cursorCol=i;
                    //如果该点有子，则显示红圈
                    if(ai.chess_board[cursorRow][cursorCol]!=C_NONE)
                        setCursor(Qt::ForbiddenCursor);

                    //展示图标坐标
                    QString str="坐标:";
                    str+=QString::number(j+1);
                    str+=",";
                    str+=QString::number(i+1);
                    if(turn==T_BLACK)ui->lb_black_position->setText(str);
                    else ui->lb_white_position->setText(str);
                    break;
                }
            }
    }
    //如果在棋盘外，显示鼠标
    else setCursor(Qt::ArrowCursor);
    update();
}

//如果有一方胜利就初始化游戏
void gameWidget::mouseReleaseEvent(QMouseEvent *event){
    if(mode==PLAYER){
        if(chessOneByPlayer()){
            if(status==FINISH){
                //游戏结束，获取到重新开始的信息就初始化游戏
                bool newgame=deadWindow(&msg);
                if(newgame) initializeGame();
            }
        }
    }else{
        if(chessOneByPlayer()){
            if(status==UNDERWAY){
                //游戏未结束，轮到ai下棋
                chessOneByAi();
                if(status==FINISH){
                    //如果ai落子后游戏结束
                    bool newgame=deadWindow(&msg);
                    if(newgame)
                        initializeGame();
                }
            }
            else if(status==FINISH){
                //玩家落子后游戏结束
                bool newgame=deadWindow(&msg);
                if(newgame)
                    initializeGame();
            }
        }
    }
}

//玩家下棋
bool gameWidget::chessOneByPlayer(){
    if(ai.chess_board[cursorRow][cursorCol]==C_NONE){
        //判断落子位置是否合法，是否是空位
        qDebug()<<"player chess";
        oneChessMove(cursorRow,cursorCol);
        //记录最新一步的落子位置
        lastCol=cursorCol;
        lastRow=cursorRow;
        hintRow=hintCol=-1;

        return true;
    }
    return false;
}

//检验棋盘是否已经被棋子填满
bool gameWidget::isDeadGame(){
    int chessNum=0;
    for(int i=0;i<15;++i)
        for(int j=0;j<15;++j)
            if(ai.chess_board[i][j]!=C_NONE)chessNum++;
    //循环遍历棋盘，是否棋子数目等于255
    if(chessNum==15*15)return true;
    else return false;
}

//检验落子的有效性
bool gameWidget::isLegalMove(int row, int col){
    if(ai.chess_board[row][col]==C_NONE)return true;
    else return false;
}

bool gameWidget::reIsLegalMove(int row, int col){
    if(usedChesses[row][col]==C_NONE)return true;
    else return false;
}

//游戏结束窗口
bool gameWidget::deadWindow(QMessageBox *msg){
    int static myCount=0;
    msg->setIcon(QMessageBox::Critical);
    //在屏幕上输出一个判定类型的窗口
    if(myCount==0){
    msg->addButton(QMessageBox::Yes);
    msg->addButton(QMessageBox::No);
    }
    //增加选择按钮

    gameResult result=ai.evaluate(ai.chess_board).result;
    if(result!=R_DRAW) status=FINISH;
    if(result==R_BLACK){
        qDebug()<<"黑棋赢";
        msg->setText("黑棋赢\n想开始下一局吗？");
        score_black++;
    }
    else if(result==R_WHITE){
        qDebug()<<"白棋赢";
        msg->setText("白棋赢\n想开始下一局吗？");
        score_write++;
    }
    else{
        qDebug()<<"平局";
        msg->setText("平局\n想开始下一局吗？");
    }
    ui->lcd_black->display(score_black);
    ui->lcd_write->display(score_write);
    int cliResult = msg->exec();
    myCount++;
    if (cliResult == QMessageBox::Yes) {
        // 用户点击了Yes按钮
        // 在这里执行相关操作
        //initializeGame();
        return true;
    } else {
        // 用户点击了No按钮
        // 在这里执行相关操作
        //此处的操作是让棋盘删除黑棋和白棋的最后一颗棋子
        return false;
    }

}
//实现落子的功能
void gameWidget::oneChessMove(int row, int col){
    numOfChess++;
    usedChesses[row][col]=numOfChess;
    //将棋谱传递给算法文件
    for(int i=0;i<15;i++){
        for(int j=0;j<15;j++){
            ai.myChess[i][j]=usedChesses[i][j];

        }
    }
    qDebug()<<row<<","<<col;
    //如果上一步是黑棋下的，记录位置，把下一步棋交给白棋，反之亦然
    if(turn==T_BLACK){
        turn=T_WHITE;
        ai.chess_board[row][col]=C_BLACK;
    }
    else{
        turn=T_BLACK;
        ai.chess_board[row][col]=C_WHITE;
    }
    //如果这步棋下完之后游戏结束，则更改游戏状态
    gameResult result=ai.evaluate(ai.chess_board).result;
    if(result!=R_DRAW||isDeadGame()) status=FINISH;

    update();
    //刷新棋盘，触发重绘
}

void gameWidget::chessOneByAi(){
    qDebug()<<"ai chess";

    struct timeval tpstart,tpend;
    float timeuse;//ai计算耗时
    gettimeofday(&tpstart,NULL);

    if(!ai.analyse_kill(ai.chess_board,16)){
        qDebug()<<"没找到杀棋";
        //如果没有杀棋就用六层的博弈树
       ai.analyse(ai.chess_board,6,-INT_MAX,INT_MAX);

    }else{
        qDebug()<<"找到了杀棋";
    }

    QPoint p=ai.decision.pos;

    if(reIsLegalMove(p.x(),p.y())){
        oneChessMove(p.x(),p.y());
        //记录最新一步的落子位置
        lastCol=p.y();
        lastRow=p.x();
    }
    else {
        qDebug()<<"ai下标不合法！";

        turn=T_WHITE;
        int roll=0;
        for(int row=0;row<15;row++){
            for(int col=0;col<15;col++){
                if(usedChesses[row][col]==0){
                    oneChessMove(row,col);
                    //记录最新一步的落子位置
                    lastCol=col;
                    lastRow=row;
                    roll=1;
                    break;
                }
            }
            if(roll) break;
        }

    }

    qDebug()<<"ai所求局势得分:"<<ai.evaluate(ai.chess_board).score;

    gettimeofday(&tpend,NULL);
    timeuse=(1000000*(tpend.tv_sec-tpstart.tv_sec) + tpend.tv_usec-tpstart.tv_usec)/1000000.0;
    qDebug()<<timeuse<<"s";

    QString text="ai计算耗时:"+QString::number(timeuse)+"s";
    this->ui->lb_timeuse->setText(text);

    text="ai局面估分:"+QString::number(ai.evaluate(ai.chess_board).score);
    this->ui->lb_eval->setText(text);
}

QPoint gameWidget::prompt(){
    int rboard[15][15];
    ai.reverseBoard(ai.chess_board,rboard);
    //反转棋盘
    if(!ai.analyse_kill(rboard,16)){
        qDebug()<<"没找到杀棋";
        //如果没有杀棋就用六层的博弈树
       ai.analyse(rboard,6,-INT_MAX,INT_MAX);

    }
    QPoint p=ai.decision.pos;
    qDebug()<<p.x()<<","<<p.y();
    hintRow=p.x();
    hintCol=p.y();
    QString message = QString("提示位置：(%1, %2)").arg(p.x()+1).arg(p.y()+1);
    //显示提示位置信息
    this->ui->label_3->setText(message);
    update();
    return p;
}

void gameWidget::reverse(){
    //反转后的棋子由AI来下，调用提示函数
    qDebug()<<"reverse";
    QPoint p=prompt();
    if(p.x()==0&&p.y()==0){
        QMessageBox msgBox;
            msgBox.setText("请落子");
            msgBox.setIcon(QMessageBox::Information);
            msgBox.exec(); // 显示消息框并等待用户响应
            return;
    }
    if(isLegalMove(p.x(),p.y())&&reIsLegalMove(p.x(),p.y())){
        oneChessMove(p.x(),p.y());
        lastCol=p.y();
        lastRow=p.x();
    }else {
        QMessageBox msgBox;
            msgBox.setText("游戏结束\n请落子");
            msgBox.setIcon(QMessageBox::Information);
            msgBox.exec(); // 显示消息框并等待用户响应
            return;
    }
    update();
}
