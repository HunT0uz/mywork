/****************************************************************************
** Meta object code from reading C++ file 'gamewidget.h'
**
** Created by: The Qt Meta Object Compiler version 67 (Qt 5.12.12)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../../../Gobang/source_code/Bigwork/gamewidget.h"
#include <QtCore/qbytearray.h>
#include <QtCore/qmetatype.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'gamewidget.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 67
#error "This file was generated using the moc from 5.12.12. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
QT_WARNING_PUSH
QT_WARNING_DISABLE_DEPRECATED
struct qt_meta_stringdata_gameWidget_t {
    QByteArrayData data[9];
    char stringdata0[87];
};
#define QT_MOC_LITERAL(idx, ofs, len) \
    Q_STATIC_BYTE_ARRAY_DATA_HEADER_INITIALIZER_WITH_OFFSET(len, \
    qptrdiff(offsetof(qt_meta_stringdata_gameWidget_t, stringdata0) + ofs \
        - idx * sizeof(QByteArrayData)) \
    )
static const qt_meta_stringdata_gameWidget_t qt_meta_stringdata_gameWidget = {
    {
QT_MOC_LITERAL(0, 0, 10), // "gameWidget"
QT_MOC_LITERAL(1, 11, 12), // "returnSignal"
QT_MOC_LITERAL(2, 24, 0), // ""
QT_MOC_LITERAL(3, 25, 10), // "returnPush"
QT_MOC_LITERAL(4, 36, 12), // "chessOneByAi"
QT_MOC_LITERAL(5, 49, 15), // "initializeGame1"
QT_MOC_LITERAL(6, 65, 6), // "regret"
QT_MOC_LITERAL(7, 72, 6), // "prompt"
QT_MOC_LITERAL(8, 79, 7) // "reverse"

    },
    "gameWidget\0returnSignal\0\0returnPush\0"
    "chessOneByAi\0initializeGame1\0regret\0"
    "prompt\0reverse"
};
#undef QT_MOC_LITERAL

static const uint qt_meta_data_gameWidget[] = {

 // content:
       8,       // revision
       0,       // classname
       0,    0, // classinfo
       7,   14, // methods
       0,    0, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       1,       // signalCount

 // signals: name, argc, parameters, tag, flags
       1,    0,   49,    2, 0x06 /* Public */,

 // slots: name, argc, parameters, tag, flags
       3,    0,   50,    2, 0x0a /* Public */,
       4,    0,   51,    2, 0x0a /* Public */,
       5,    0,   52,    2, 0x0a /* Public */,
       6,    0,   53,    2, 0x0a /* Public */,
       7,    0,   54,    2, 0x0a /* Public */,
       8,    0,   55,    2, 0x0a /* Public */,

 // signals: parameters
    QMetaType::Void,

 // slots: parameters
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::QPoint,
    QMetaType::Void,

       0        // eod
};

void gameWidget::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    if (_c == QMetaObject::InvokeMetaMethod) {
        auto *_t = static_cast<gameWidget *>(_o);
        Q_UNUSED(_t)
        switch (_id) {
        case 0: _t->returnSignal(); break;
        case 1: _t->returnPush(); break;
        case 2: _t->chessOneByAi(); break;
        case 3: _t->initializeGame1(); break;
        case 4: _t->regret(); break;
        case 5: { QPoint _r = _t->prompt();
            if (_a[0]) *reinterpret_cast< QPoint*>(_a[0]) = std::move(_r); }  break;
        case 6: _t->reverse(); break;
        default: ;
        }
    } else if (_c == QMetaObject::IndexOfMethod) {
        int *result = reinterpret_cast<int *>(_a[0]);
        {
            using _t = void (gameWidget::*)();
            if (*reinterpret_cast<_t *>(_a[1]) == static_cast<_t>(&gameWidget::returnSignal)) {
                *result = 0;
                return;
            }
        }
    }
}

QT_INIT_METAOBJECT const QMetaObject gameWidget::staticMetaObject = { {
    &QWidget::staticMetaObject,
    qt_meta_stringdata_gameWidget.data,
    qt_meta_data_gameWidget,
    qt_static_metacall,
    nullptr,
    nullptr
} };


const QMetaObject *gameWidget::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *gameWidget::qt_metacast(const char *_clname)
{
    if (!_clname) return nullptr;
    if (!strcmp(_clname, qt_meta_stringdata_gameWidget.stringdata0))
        return static_cast<void*>(this);
    return QWidget::qt_metacast(_clname);
}

int gameWidget::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QWidget::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 7)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 7;
    } else if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 7)
            *reinterpret_cast<int*>(_a[0]) = -1;
        _id -= 7;
    }
    return _id;
}

// SIGNAL 0
void gameWidget::returnSignal()
{
    QMetaObject::activate(this, &staticMetaObject, 0, nullptr);
}
QT_WARNING_POP
QT_END_MOC_NAMESPACE
