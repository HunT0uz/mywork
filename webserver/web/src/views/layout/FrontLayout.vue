<template>
  <el-container class="my-container">
    <el-header class="my-header">
      <el-row class="nav">
        <el-col :span="4" class="logo">
        </el-col>
        <el-col :span="16">
          <div style="text-align: center">
            <el-menu
                :default-active="useRoute().path"
                mode="horizontal"
                router
                @select="handleSelect"
            >
              <el-menu-item index="/index">首页</el-menu-item>
              <el-menu-item index="/productList">商品列表</el-menu-item>
              <el-menu-item index="/shoppingCart">购物车</el-menu-item>
              <el-menu-item index="/productOrder">我的订单</el-menu-item>
              <el-menu-item index="/personalCenter">个人中心</el-menu-item>

            </el-menu>
          </div>
        </el-col>
        <el-col :span="4">
          <div style="text-align: center;">
            <el-space style="margin-top: 5px;">
              <el-dropdown v-if="isUserLogin">
                <div>
                  <el-space>
                    <el-avatar style="width: 20px;height: 20px;border-radius: 50%"
                               shape="square" :size="20" :src="currentUser.avatarUrl"></el-avatar>
                    <span style="font-size: 16px">  {{ currentUser.username }}</span></el-space>
                </div>
                <template #dropdown>
                  <el-dropdown-menu>
                    <el-dropdown-item><span @click="editCurrentUser">个人信息</span></el-dropdown-item>
                    <el-dropdown-item><span @click="editPassword">修改密码</span></el-dropdown-item>
                    <el-dropdown-item><span @click="balanceInfo">余额/充值</span></el-dropdown-item>
                    <el-dropdown-item divided><span @click="logout">退出登录</span></el-dropdown-item>
                  </el-dropdown-menu>
                </template>
              </el-dropdown>
            </el-space>
          </div>
        </el-col>
      </el-row>
    </el-header>
    <el-main class="my-main">
      <router-view/>
    </el-main>
    <el-footer class="my-footer">
      <p>在线商城系统 </p>
    </el-footer>
  </el-container>
</template>

<script setup>
import tools from "@/utils/tools.js";
import {ref} from "vue";
import router from "@/router/index.js";
import {ElMessage} from "element-plus";
import {useRoute} from "vue-router";

const isUserLogin = ref(tools.isLogin())
const currentUser = ref(tools.getCurrentUser())

if (currentUser.value === null) {
  window.location.href = "/login"
}
if (currentUser.value && currentUser.value.type !== 'USER') {
  router.push({path: "/admin"})
}

function handleSelect(key, keyPath) {
  console.log(key, keyPath);
}

function logout() {
  ElMessage({
    message: '退出登录成功，正在跳转',
    type: 'success'
  });
  localStorage.clear()
  router.push({path: "/login"})
}

function editCurrentUser() {
  router.push({path: "/editCurrentUser"})
}

function editPassword() {
  router.push({path: "/editPassword"})
}
function balanceInfo() {
  router.push({path: "/balanceInfo"})
}

</script>


<style scoped>
.el-menu--horizontal {
  --el-menu-horizontal-height: 30px;
}
.my-container {
  display: flex;
  flex-direction: column;
  height: 100vh; /* 例如，设置为视窗的高度 */
}

.my-header {
  height: 30px;
}

.el-menu.el-menu--horizontal {
  border-bottom: none;
}

.my-main {
  background-color: white
}
.my-main::-webkit-scrollbar {
  display: none; /* 隐藏滚动条 */
}
.my-footer {
  font-size: 14px;
  padding: 10px;
  color: #999;
  background-color: white;
  text-align: center;
}
</style>

