import mysql.connector
from mysql.connector import Error
from datetime import datetime
import pandas as pd

def convert_date(date_str):
    """将日期字符串转换为标准格式（仅年月日）"""
    if date_str is None:
        return "null"

    # 清理输入日期字符串
    date_str = date_str.strip().replace('日', '').replace('月', '-').replace('年', '-')

    now = datetime.now()
    current_year = now.year

    # 处理自然语言描述的日期
    if "前" in date_str or "小时" in date_str or "天前" in date_str:
        time_part = date_str.split("小时前")[0] if "小时" in date_str else date_str
        if "天前" in time_part:
            days_ago = int(time_part.replace("天前", "").strip())
            date = now - pd.DateOffset(days=days_ago)
            return date.strftime('%Y-%m-%d')
        elif "小时前" in time_part:
            hours_ago = int(time_part.replace("小时前", "").strip())
            date = now - pd.DateOffset(hours=hours_ago)
            return date.strftime('%Y-%m-%d')
        else:
            return now.strftime('%Y-%m-%d')

    # 处理完整的日期格式
    if "-" in date_str:
        try:
            return datetime.strptime(date_str, '%Y-%m-%d').strftime('%Y-%m-%d')
        except ValueError:
            pass

    # 如果不包含年份，添加当前年份
    if "-" in date_str:
        date_str = f"{current_year}-{date_str}"
        try:
            return datetime.strptime(date_str, '%Y-%m-%d').strftime('%Y-%m-%d')
        except ValueError:
            pass
    else:
        month_day = date_str.replace("月", "-").replace("日", "")
        date_str = f"{current_year}-{month_day}"
        try:
            return datetime.strptime(date_str, '%Y-%m-%d').strftime('%Y-%m-%d')
        except ValueError:
            return "error"

def connect_to_db():
    """连接到 MySQL 数据库"""
    host_name = "localhost"
    user_name = "root"
    user_password = "1234"  # 替换为您的数据库密码
    db_name = "crawlerarticledb"

    try:
        connection = mysql.connector.connect(
            host=host_name,
            user=user_name,
            password=user_password,
            database=db_name
        )
        print("成功连接到数据库")
        return connection
    except Error as e:
        print(f"数据库连接错误: {e}")
        return None

def fetch_dates(connection):
    """从数据库中提取日期数据"""
    date_list = []
    try:
        if connection.is_connected():
            cursor = connection.cursor()
            cursor.execute("SELECT 发布时间 FROM articles")  # 替换为您的表和字段名
            rows = cursor.fetchall()
            for row in rows:
                date_list.append(row[0])  # 假设日期在第一列
            print("成功获取日期数据。")
    except Error as e:
        print(f"查询错误: {e}")
    return date_list

def update_date(connection, original_date, converted_date):
    """更新数据库中的日期"""
    try:
        if connection.is_connected():
            cursor = connection.cursor()
            update_query = "UPDATE articles SET converted_date = %s WHERE 发布时间 = %s"  # 替换为您的表和字段名
            cursor.execute(update_query, (converted_date, original_date))  # 使用原始日期进行匹配
            connection.commit()  # 提交更改
            print(f"成功更新日期: {original_date} 为 {converted_date}")
    except Error as e:
        print(f"更新错误: {e}")

def main():
    """主程序逻辑"""
    connection = connect_to_db()
    if connection:
        date_data = fetch_dates(connection)

        # 转换日期并在对应位置更新数据库
        for original_date in date_data:
            converted_date = convert_date(original_date)
            if converted_date not in ["null", "error"]:
                update_date(connection, original_date, converted_date)  # 更新对应的日期

        # 关闭数据库连接
        if connection.is_connected():
            connection.close()
            print("数据库连接已关闭。")

if __name__ == "__main__":
    main()
