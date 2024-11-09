import mysql.connector
from mysql.connector import Error
from sparkai.llm.llm import ChatSparkLLM, ChunkPrintHandler
from sparkai.core.messages import ChatMessage
import os  # 导入 os 库以创建目录
import datetime  # 导入 datetime 库以使用时间戳
import re  # 引入 re 模块用于正则表达式处理

# 星火认知大模型的URL等信息
SPARKAI_URL = 'wss://spark-api.xf-yun.com/v3.5/chat'
SPARKAI_APP_ID = 'f559e2a0'
SPARKAI_API_SECRET = 'ODQ0MzdiOTY2ZDc1YWZiYzUwM2QyMzY4'
SPARKAI_API_KEY = 'd93f61186bcb5c53cfce0585fd9b418c'
SPARKAI_DOMAIN = 'generalv3.5'

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

def fetch_articles_from_db(connection):
    """从数据库中提取文章标题、内容和百度链接"""
    articles = []
    try:
        if connection.is_connected():
            cursor = connection.cursor()
            cursor.execute("SELECT 标题, 网站内容, 百度链接 FROM articles")  # 确保表名和字段名正确
            articles = cursor.fetchall()  # 获取所有查询结果
            print(f"成功获取到 {len(articles)} 篇文章。")
    except Error as e:
        print(f"数据库错误: {e}")  # 输出数据库错误信息
    return articles  # 返回包含标题、内容和链接的文章列表

def is_unique_title(title, connection):
    """检查标题在数据库中是否唯一"""
    try:
        if connection.is_connected():
            cursor = connection.cursor()
            cursor.execute("SELECT COUNT(*) FROM articles_summary WHERE title = %s", (title,))
            result = cursor.fetchone()
            return result[0] == 0  # 0 表示该标题在数据库中是唯一的
    except Error as e:
        print(f"数据库错误: {e}")
    return True  # 默认返回唯一

def generate_keywords(title, article):
    """生成关键词，只提取三个关键词"""
    spark = ChatSparkLLM(
        spark_api_url=SPARKAI_URL,
        spark_app_id=SPARKAI_APP_ID,
        spark_api_key=SPARKAI_API_KEY,
        spark_api_secret=SPARKAI_API_SECRET,
        spark_llm_domain=SPARKAI_DOMAIN,
        streaming=False,
    )

    content_with_instruction = f"{title}\n内容: {article}\n\n请提取三个关键词，以逗号分隔："
    messages = [ChatMessage(role="user", content=content_with_instruction)]

    handler = ChunkPrintHandler()
    try:
        response = spark.generate([messages], callbacks=[handler])

        if hasattr(response, 'generations') and len(response.generations) > 0:
            keywords = response.generations[0][0].text.strip()
            return ', '.join(keywords.split(',')[:3])  # 只取前3个关键词
    except Exception as e:
        print(f"生成关键词时发生错误: {e}")
    return ""

def generate_technology(title, article):
    """生成AI技术，只提取三个AI技术"""
    spark = ChatSparkLLM(
        spark_api_url=SPARKAI_URL,
        spark_app_id=SPARKAI_APP_ID,
        spark_api_key=SPARKAI_API_KEY,
        spark_api_secret=SPARKAI_API_SECRET,
        spark_llm_domain=SPARKAI_DOMAIN,
        streaming=False,
    )

    content_with_instruction = f"{title}\n内容: {article}\n\n请提取三个AI技术，以逗号分隔："
    messages = [ChatMessage(role="user", content=content_with_instruction)]

    handler = ChunkPrintHandler()
    try:
        response = spark.generate([messages], callbacks=[handler])

        if hasattr(response, 'generations') and len(response.generations) > 0:
            ai_technology = response.generations[0][0].text.strip()
            return ', '.join(ai_technology.split(',')[:3])  # 只取前3个AI技术
    except Exception as e:
        print(f"生成AI技术时发生错误: {e}")
    return ""

def generate_industry(title, article):
    """生成行业，只提取三个行业"""
    spark = ChatSparkLLM(
        spark_api_url=SPARKAI_URL,
        spark_app_id=SPARKAI_APP_ID,
        spark_api_key=SPARKAI_API_KEY,
        spark_api_secret=SPARKAI_API_SECRET,
        spark_llm_domain=SPARKAI_DOMAIN,
        streaming=False,
    )

    content_with_instruction = f"{title}\n内容: {article}\n\n请提取三个行业，以逗号分隔："
    messages = [ChatMessage(role="user", content=content_with_instruction)]

    handler = ChunkPrintHandler()
    try:
        response = spark.generate([messages], callbacks=[handler])

        if hasattr(response, 'generations') and len(response.generations) > 0:
            industry = response.generations[0][0].text.strip()
            return ', '.join(industry.split(',')[:3])  # 只取前3个行业
    except Exception as e:
        print(f"生成行业时发生错误: {e}")
    return ""

def clean_filename(title):
    """清理标题，生成合法的文件名"""
    # 使用正则表达式替换不合法字符
    return re.sub(r'[<>:"/\\|?*]', '', title)[:255]  # 限制文件名长度

def save_summary_to_file(title, url, summary, keywords, ai_technology, industry):
    """保存标题、链接和AI生成的总结到summary文件夹"""
    # 创建summary文件夹
    if not os.path.exists('summary'):
        os.makedirs('summary')

    # 清理标题以生成合法的文件名
    safe_title = clean_filename(title)

    # 文件路径为每篇文章单独保存
    summary_file_path = os.path.join('summary', f'summary_{safe_title}.txt')

    with open(summary_file_path, 'w', encoding='utf-8') as f:
        f.write(f"标题: {title}\n链接: {url}\n总结: {summary}\n关键词: {keywords}\nAI技术: {ai_technology}\n行业: {industry}\n")

    print(f"总结信息已保存到 {summary_file_path}")

def insert_into_database(connection, title, url, keywords, ai_technology, industry):
    """插入数据到数据库"""
    if connection:
        cursor = connection.cursor()
        try:
            now = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")  # 获取当前时间戳
            cursor.execute("""
                INSERT INTO articles_summary (title, url, keywords, ai_technology, industry, created_at) 
                VALUES (%s, %s, %s, %s, %s, %s)
            """, (title, url, keywords, ai_technology, industry, now))

            connection.commit()
            print(f"信息已插入到数据库: {title}")
        except Error as e:
            print(f"插入数据库时发生错误: {e}")

def main():
    connection = connect_to_db()

    if connection:
        # 获取文章列表
        articles = fetch_articles_from_db(connection)

        for article in articles:
            title, content, url = article
            if is_unique_title(title, connection):
                # 仅使用前8000个字符
                truncated_content = content[:8000]

                # 生成关键词、AI技术和行业，发生错误时跳过处理
                keywords = generate_keywords(title, truncated_content)
                ai_technology = generate_technology(title, truncated_content)
                industry = generate_industry(title, truncated_content)

                # 一次性插入数据到数据库
                insert_into_database(connection, title, url, keywords, ai_technology, industry)

                # 保存总结到文件
                save_summary_to_file(title, url, content, keywords, ai_technology, industry)

            else:
                print(f"标题 {title} 已经存在，跳过处理。")

        # 关闭数据库连接
        if connection.is_connected():
            connection.close()
            print("数据库连接已关闭。")
    else:
        print("无法连接到数据库，跳过处理。")

if __name__ == '__main__':
    main()
