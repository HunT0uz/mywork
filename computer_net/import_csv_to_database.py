# import pandas as pd
# from sqlalchemy import create_engine
# from mysql.connector import Error
# import tkinter as tk
# from tkinter import filedialog, messagebox
#
# # 连接数据库的配置函数
# def connect_to_db(user_name, user_password, db_name):
#     """连接到 MySQL 数据库并返回连接对象"""
#     host_name = "localhost"  # 本机连接
#
#     # 使用正确的连接字符串
#     connection_string = f"mysql+mysqlconnector://{user_name}:{user_password}@{host_name}/{db_name}"
#     try:
#         engine = create_engine(connection_string)
#         # 测试连接
#         with engine.connect() as connection:
#             print("MySQL Database connection successful")
#         return engine
#     except Error as e:
#         print(f"The error '{e}' occurred")
#         return None
#
# # 导入CSV到数据库的函数
# def import_csv_to_db(engine, csv_file_path, table_name):
#     """从CSV导入数据到MySQL数据库"""
#     try:
#         df = pd.read_csv(csv_file_path)
#         # 过滤掉网站内容为空的行
#         df = df[df['网站内容'].notna()]  # 假设网站内容存在 '网站内容' 列中
#
#         # 检查过滤后是否还有数据可以导入
#         if df.empty:
#             messagebox.showerror("Error", "No valid data to import after filtering.")
#             return
#
#         # 进行数据追加
#         df.to_sql(table_name, con=engine, if_exists='append', index=False)
#         messagebox.showinfo("Success", "CSV file has been imported successfully")
#     except Exception as e:
#         messagebox.showerror("Error", f"Failed to import CSV: {e}")
#         print(f"Failed to import CSV: {e}")
#     finally:
#         print("MySQL connection is closed")  # SQLAlchemy 自动管理连接，无需手动关闭
#
# # 选择CSV文件的函数
# def select_csv_file():
#     csv_file_path = filedialog.askopenfilename(
#         title="Select CSV file",
#         filetypes=[("CSV files", "*.csv")]
#     )
#     if csv_file_path:
#         entry_csv.delete(0, tk.END)
#         entry_csv.insert(0, csv_file_path)
#
# # 执行导入操作的函数
# def execute_import():
#     csv_file_path = entry_csv.get()
#
#     if not csv_file_path:
#         messagebox.showerror("Error", "Please select a CSV file")
#         return
#
#     engine = connect_to_db("root", "1234", "crawlerarticledb")  # 请把用户名、密码和数据库名根据实际情况修改
#     if engine is not None:
#         import_csv_to_db(engine, csv_file_path, "articles")  # 请把表名替换为你实际的表名
#
# # 创建主窗口
# root = tk.Tk()
# root.title("CSV to MySQL Importer")
#
# # 创建输入框和标签
# label_csv = tk.Label(root, text="CSV File:")
# label_csv.grid(row=0, column=0)
# entry_csv = tk.Entry(root)
# entry_csv.grid(row=0, column=1)
#
# # 创建按钮
# btn_select_csv = tk.Button(root, text="Select CSV", command=select_csv_file)
# btn_select_csv.grid(row=0, column=2)
#
# btn_import = tk.Button(root, text="Import", command=execute_import)
# btn_import.grid(row=1, column=1)
#
# # 运行主循环
# root.mainloop()
