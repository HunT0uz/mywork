import tkinter as tk
from tkinter import filedialog, messagebox, Scrollbar, Text, Label, simpledialog
import pandas as pd
from sqlalchemy import create_engine
from mysql.connector import Error
import webbrowser
from sparkai.llm.llm import ChatSparkLLM, ChunkPrintHandler
from sparkai.core.messages import ChatMessage

SPARKAI_URL = 'wss://spark-api.xf-yun.com/v3.5/chat'
SPARKAI_APP_ID = 'f559e2a0'
SPARKAI_API_SECRET = 'ODQ0MzdiOTY2ZDc1YWZiYzUwM2QyMzY4'
SPARKAI_API_KEY = 'd93f61186bcb5c53cfce0585fd9b418c'
SPARKAI_DOMAIN = 'generalv3.5'

search_results = None

# 连接到数据库的函数
def connect_to_db():
    host_name = "localhost"
    user_name = "root"
    user_password = "1234"
    db_name = "crawlerarticledb"
    connection_string = f"mysql+mysqlconnector://{user_name}:{user_password}@{host_name}/{db_name}"
    try:
        engine = create_engine(connection_string)
        with engine.connect() as connection:
            print("成功连接到数据库")
        return engine
    except Error as e:
        print(f"发生错误: {e}")
        return None

# 将CSV文件导入到数据库的函数
def import_csv_to_db(engine, csv_file_path, table_name):
    try:
        df = pd.read_csv(csv_file_path)

        # 检查并处理链接
        if '百度链接' not in df.columns or '网站内容' not in df.columns:
            messagebox.showerror("错误", "CSV 必须包含 '百度链接' 和 '网站内容' 列。")
            return

        df = df[df['网站内容'].notna()]
        if df.empty:
            messagebox.showerror("错误", "过滤后没有有效数据可以导入。")
            return

        df.to_sql(table_name, con=engine, if_exists='append', index=False)
        messagebox.showinfo("成功", "CSV 文件已经成功导入")
    except Exception as e:
        messagebox.showerror("错误", f"导入CSV失败: {e}")

# 选择CSV文件的函数
def select_csv_file():
    csv_file_path = filedialog.askopenfilename(
        title="选择CSV文件",
        filetypes=[("CSV 文件", "*.csv")]
    )
    if csv_file_path:
        entry_csv.delete(0, tk.END)
        entry_csv.insert(0, csv_file_path)

# 执行导入操作的函数
def execute_import():
    csv_file_path = entry_csv.get()
    if not csv_file_path:
        messagebox.showerror("错误", "请选择一个CSV文件")
        return
    engine = connect_to_db()
    if engine is not None:
        import_csv_to_db(engine, csv_file_path, "articles")  # 确保插入到 articles 表

# 搜索数据库的函数
def search_database():
    global search_results
    keyword = simpledialog.askstring("输入", "请输入搜索关键词:")
    if not keyword:
        return
    engine = connect_to_db()
    if engine is not None:
        query = f"SELECT 标题, 网站内容, 简介, 百度链接, 发布时间 FROM articles WHERE 网站内容 LIKE '%{keyword}%'"
        search_results = pd.read_sql(query, engine)
        search_results = search_results.drop_duplicates(subset='百度链接')
        if search_results.empty:
            messagebox.showinfo("搜索结果", "未找到结果.")
        else:
            create_result_window(search_results)

# 创建搜索结果窗口的函数
def create_result_window(results):
    result_window = tk.Toplevel()
    result_window.title("搜索结果")
    result_window.geometry("800x600")
    scroll_bar = Scrollbar(result_window)
    scroll_bar.grid(row=0, column=1, sticky='ns')
    listbox = tk.Listbox(result_window, selectmode=tk.SINGLE, yscrollcommand=scroll_bar.set, width=70, height=20, font=("微软雅黑", 14))
    for index, row in results.iterrows():
        listbox.insert(tk.END, row['标题'])
    listbox.grid(row=0, column=0, padx=10, pady=10, sticky='nsew')
    scroll_bar.config(command=listbox.yview)
    view_button = tk.Button(result_window, text="查看文章", command=lambda: view_article(listbox, results), width=15)
    view_button.grid(row=1, column=0, columnspan=2, pady=10)
    stats_button = tk.Button(result_window, text="统计搜索结果数量", command=lambda: show_statistics(results), width=20)
    stats_button.grid(row=2, column=0, columnspan=2, pady=10)
    result_window.grid_rowconfigure(0, weight=1)
    result_window.grid_columnconfigure(0, weight=1)

# 显示统计信息的函数
def show_statistics(results):
    if results is not None and not results.empty:
        try:
            total_count = results.shape[0]
            duplicate_links = results.duplicated(subset='百度链接', keep=False)
            duplicate_count = duplicate_links.sum()
            duplicate_links_list = results[duplicate_links]['百度链接'].unique().tolist()
            similar_content = results['网站内容'].duplicated(keep=False)
            similar_count = similar_content.sum()
            similar_content_list = results[similar_content]['网站内容'].unique().tolist()
            messagebox.showinfo(
                "统计结果",
                f"搜索结果总数量: {total_count}\n"
                f"重复网页数量 (链接相同): {duplicate_count} (类型: {', '.join(duplicate_links_list)})\n"
                f"相似网页数量 (内容相似): {similar_count} (类型: {', '.join(similar_content_list)})"
            )
        except Exception as e:
            messagebox.showerror("错误", f"统计过程发生错误: {e}")

# 显示所有统计信息的函数
def show_all_statistics():
    engine = connect_to_db()
    if engine is not None:
        try:
            query_total = "SELECT COUNT(*) FROM articles"
            query_duplicates = """  
                SELECT COUNT(*)   
                FROM (SELECT 百度链接, COUNT(*) AS cnt   
                      FROM articles   
                      GROUP BY 百度链接   
                      HAVING cnt > 1) AS duplicates  
            """
            query_similar = """  
                SELECT COUNT(*)   
                FROM (SELECT 网站内容, COUNT(*) AS cnt   
                      FROM articles   
                      GROUP BY 网站内容   
                      HAVING cnt > 1) AS similar  
            """
            total_count = pd.read_sql(query_total, engine).iloc[0, 0]
            duplicate_count = pd.read_sql(query_duplicates, engine).iloc[0, 0]
            similar_count = pd.read_sql(query_similar, engine).iloc[0, 0]
            messagebox.showinfo("统计结果", f"所有网页数量: {total_count}\n重复网页数量 (链接相同): {duplicate_count}\n相似网页数量 (内容相似): {similar_count}")
        except Exception as e:
            messagebox.showerror("错误", f"统计过程发生错误: {e}")

# 生成总结的函数
def generate_summary(title, article):
    spark = ChatSparkLLM(
        spark_api_url=SPARKAI_URL,
        spark_app_id=SPARKAI_APP_ID,
        spark_api_key=SPARKAI_API_KEY,
        spark_api_secret=SPARKAI_API_SECRET,
        spark_llm_domain=SPARKAI_DOMAIN,
        streaming=False,
    )

    # 只获取前8000个字符
    if len(article) > 8000:
        article = article[:8000]  # 截取到8000个字符

    content_with_instruction = f"{title}\n内容: {article}\n\n提取网页中的观点、AI技术、应用领域或行业、重大事件并将其用中文列出来。"
    messages = [ChatMessage(
        role="user",
        content=content_with_instruction
    )]
    handler = ChunkPrintHandler()
    try:
        response = spark.generate([messages], callbacks=[handler])
        if hasattr(response, 'generations') and len(response.generations) > 0:
            summary_text = response.generations[0][0].text
            return summary_text.strip()
        return "无法生成总结"
    except Exception as e:
        print(f"生成总结时发生错误: {e}")
        return "生成总结时发生错误"


# 查看文章的函数
def view_article(listbox, results):
    selected_index = listbox.curselection()
    if not selected_index:
        return
    index = selected_index[0]
    open_article_window(results, index)

# 打开文章窗口的函数
def open_article_window(results, index):
    article_window = tk.Toplevel()
    article_window.title("文章查看")

    # 字体大小初始化
    title_font_size = 24
    intro_font_size = 16
    text_font_size = 14

    # 创建标题标签
    title_label = Label(article_window, text=results.iloc[index]['标题'], font=("微软雅黑", title_font_size, "bold"))
    title_label.grid(row=0, column=0, sticky='w', padx=10, pady=10)

    # 显示发布时间
    publish_time = results.iloc[index]['发布时间']
    publish_time_label = Label(article_window, text=f"发布时间: {publish_time}", font=("微软雅黑", intro_font_size))
    publish_time_label.grid(row=1, column=0, sticky='w', padx=10)

    # 创建简介的滚动文本框
    intro_text = results.iloc[index]['简介']

    # 创建滚动条
    intro_scroll_bar = Scrollbar(article_window)
    intro_scroll_bar.grid(row=2, column=1, sticky='ns')

    # 创建文本框
    intro_text_area = Text(article_window, wrap=tk.WORD, yscrollcommand=intro_scroll_bar.set, font=("微软雅黑", intro_font_size), height=5)
    intro_text_area.grid(row=2, column=0, sticky='w', padx=10)

    intro_text_area.insert(tk.END, intro_text)
    intro_text_area.config(state=tk.DISABLED)  # 设置为只读

    intro_scroll_bar.config(command=intro_text_area.yview)

    # 获取文章内容
    article_content = results.iloc[index]['网站内容']
    summary_button = tk.Button(article_window, text="生成AI总结", command=lambda: show_summary(title_label.cget("text"), article_content))
    summary_button.grid(row=3, column=0, padx=10)

    # 创建链接按钮
    url = results.iloc[index]['百度链接']
    link_button = tk.Button(article_window, text="打开链接", command=lambda: open_link(url))
    link_button.grid(row=4, column=0, pady=10)

    scroll_bar = Scrollbar(article_window)
    scroll_bar.grid(row=5, column=1, sticky='ns')

    # 创建文本框
    text_area = Text(article_window, wrap=tk.WORD, yscrollcommand=scroll_bar.set, font=("微软雅黑", text_font_size))
    text_area.grid(row=5, column=0, padx=10, pady=20, sticky='nsew')
    scroll_bar.config(command=text_area.yview)

    # 显示原始文章内容
    text_area.insert(tk.END, article_content)

    # 自适应窗口
    article_window.grid_rowconfigure(5, weight=1)
    article_window.grid_columnconfigure(0, weight=1)

# 显示总结的函数
def show_summary(title, content):
    summary = generate_summary(title, content)
    summary_window = tk.Toplevel()
    summary_window.title("AI总结")
    scroll_bar = Scrollbar(summary_window)
    scroll_bar.pack(side=tk.RIGHT, fill=tk.Y)
    summary_text_area = Text(summary_window, wrap=tk.WORD, yscrollcommand=scroll_bar.set, font=("微软雅黑", 14))
    summary_text_area.insert(tk.END, summary)
    summary_text_area.pack(padx=10, pady=10, fill=tk.BOTH, expand=True)
    scroll_bar.config(command=summary_text_area.yview)

# 打开链接的函数
def open_link(url):
    if pd.notnull(url):
        webbrowser.open(url)

# 创建主窗口
root = tk.Tk()
root.title("CSV导入到MySQL & 文章搜索")
label_csv = tk.Label(root, text="CSV 文件:")
label_csv.grid(row=0, column=0)
entry_csv = tk.Entry(root, width=60)
entry_csv.grid(row=0, column=1)
btn_select_csv = tk.Button(root, text="选择CSV文件", command=select_csv_file)
btn_select_csv.grid(row=0, column=2)
btn_import_csv = tk.Button(root, text="导入CSV到数据库", command=execute_import)
btn_import_csv.grid(row=1, column=1)
btn_search = tk.Button(root, text="搜索文章", command=search_database)
btn_search.grid(row=1, column=0)
btn_all_stats = tk.Button(root, text="统计所有网页数量", command=show_all_statistics)
btn_all_stats.grid(row=1, column=2)
root.geometry("600x200")
root.mainloop()
