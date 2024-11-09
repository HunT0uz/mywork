import mysql.connector
from mysql.connector import Error
from collections import Counter
import re
import tkinter as tk
from tkinter import scrolledtext

def connect_to_db():
    """连接到 MySQL 数据库并返回连接对象"""
    host_name = "localhost"
    user_name = "root"
    user_password = "1234"
    db_name = "crawlerarticledb"  # 替换为您的数据库名称
    connection = None
    try:
        connection = mysql.connector.connect(
            host=host_name,
            user=user_name,
            password=user_password,
            database=db_name
        )
        print("成功连接到数据库")
    except Error as e:
        print(f"数据库连接错误: {e}")
    return connection

def fetch_data_from_db(connection):
    """从数据库中提取关键词、AI技术和行业"""
    keywords_list = []
    ai_technology_list = []
    industry_list = []

    try:
        if connection.is_connected():
            cursor = connection.cursor()
            cursor.execute("SELECT keywords, ai_technology, industry FROM articles_summary")  # 确保表名和字段名正确
            rows = cursor.fetchall()
            for row in rows:
                keywords_list.append(row[0])
                ai_technology_list.append(row[1])
                industry_list.append(row[2])
            print(f"成功获取到 {len(rows)} 条记录。")
    except Error as e:
        print(f"数据库错误: {e}")

    return keywords_list, ai_technology_list, industry_list

def count_frequency(word_list):
    """统计词汇的频率"""
    all_words = []
    for words in word_list:
        if words:  # 确保不为空
            all_words.extend(re.split(r'[,\s]+', words.strip()))
    return Counter(all_words)

def run_statistics():
    """运行统计并更新GUI显示"""
    connection = connect_to_db()
    if connection:
        keywords, ai_technology, industry = fetch_data_from_db(connection)

        # 统计频率
        keywords_freq = count_frequency(keywords)
        ai_technology_freq = count_frequency(ai_technology)
        industry_freq = count_frequency(industry)

        result_text.delete(1.0, tk.END)  # 清空文本框

        # 打印高频词汇到文本框
        result_text.insert(tk.END, "关键词高频词汇统计：\n")
        for word, count in keywords_freq.most_common(10):
            result_text.insert(tk.END, f"{word}: {count}\n")

        result_text.insert(tk.END, "\nAI技术高频词汇统计：\n")
        for word, count in ai_technology_freq.most_common(10):
            result_text.insert(tk.END, f"{word}: {count}\n")

        result_text.insert(tk.END, "\n行业高频词汇统计：\n")
        for word, count in industry_freq.most_common(10):
            result_text.insert(tk.END, f"{word}: {count}\n")

        # 关闭数据库连接
        if connection.is_connected():
            connection.close()
            print("数据库连接已关闭。")
    else:
        result_text.insert(tk.END, "无法连接到数据库，跳过处理。\n")

# 创建GUI窗口
window = tk.Tk()
window.title("高频词汇统计")
window.geometry("400x400")

# 创建按钮以运行统计
run_button = tk.Button(window, text="运行统计", command=run_statistics)
run_button.pack(pady=10)

# 创建文本框以显示结果
result_text = scrolledtext.ScrolledText(window, wrap=tk.WORD, width=50, height=20)
result_text.pack(pady=10)

# 启动GUI循环
window.mainloop()
