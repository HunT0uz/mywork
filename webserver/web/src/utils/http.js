import axios from "axios";
import router from "../router";
import {ElMessage} from "element-plus";

// 设置 Axios 的默认基础 URL
const baseURL = 'http://localhost:1000';
axios.defaults.baseURL = baseURL;

// 创建 Axios 实例
const http = axios.create({
    baseURL,
    timeout: 5000,
    headers: {
        'Content-Type': 'application/json'
    }
});

// 不需要token的白名单路径
const whiteList = [
    '/common/login',
    '/common/register',
    '/common/retrievePassword',
    '/file/upload',
    '/error',
    '/swagger-ui',
    '/v3/api-docs'
];

// 请求拦截器
http.interceptors.request.use(config => {
    // 如果请求路径在白名单中，不需要token
    const isWhiteList = whiteList.some(path => config.url.includes(path));
    if (!isWhiteList && localStorage.getItem("token")) {
        config.headers["token"] = localStorage.getItem("token");
    }
    return config;
});

// 响应拦截器
http.interceptors.response.use(
    response => {
        return response.data;
    },
    error => {
        if (error.response) {
            if (error.response.status === 401) {
                ElMessage.error('登录已过期，请重新登录');
                localStorage.clear();
                router.push('/login');
            } else {
                ElMessage.error(error.response.data.message || '请求失败');
            }
        } else {
            ElMessage.error('网络错误，请稍后重试');
        }
        return Promise.reject(error);
    }
);

// 打印环境变量
console.log("环境:", import.meta.env.NODE_ENV);
console.log("服务器:", import.meta.env.VUE_APP_SERVER);
console.log("所有环境变量:", import.meta.env);

// 导出 baseURL 供其他组件使用
export const apiBaseURL = baseURL;
export default http;

