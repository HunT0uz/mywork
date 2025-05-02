<template>
  <div class="main-context">
    <el-card class="box-card">
      <el-space direction="vertical" style="width: 100%" size="large">
        <el-space>
          <img src="../assets/logo.png" width="100%" style="width: 55px">
          <el-space direction="vertical" style="width: 100%" size="small">
            <h2 style="font-style: oblique">Brian's Shop</h2>
          </el-space>
        </el-space>
        <el-form :model="formData" label-width="80px" :rules="rules" ref="formRef" style="width: 100%" >
          <el-form-item label="头像" prop="avatarUrl"
                        style="width: 100%"
                        :rules="[{required:false,message:'请选择头像',trigger:[ 'blur','change']}]">
            <MyUpLoad type="imageCard" :limit="1" :files="formData.avatarUrl"
                      @setFiles="formData.avatarUrl = $event"></MyUpLoad>
          </el-form-item>
          <el-form-item label="用户类型" prop="type"
                        :rules="[{required:true,message:'请选择类型',trigger:[ 'blur','change']}]">
            <el-select v-model="formData.type" placeholder="请选择用户类型" style="width: 180px">
              <el-option label="用户" value="USER"></el-option>
              <el-option label="店铺" value="SHOP"></el-option>
            </el-select>
          </el-form-item>

          <!-- 用户名、密码、昵称是两种类型都需要的字段 -->
          <el-form-item label="用户名" prop="username"
                        :rules="[{required:true,message:'请输入用户名',trigger:[ 'blur','change']}]">
            <el-input
                style="width: 180px"
                placeholder="请输入用户名"
                v-model.trim="formData.username"
                clearable
            >
            </el-input>
          </el-form-item>
          <el-form-item label="密码" prop="password"
                        :rules="[{required:true,message:'请输入密码',trigger:[ 'blur','change']}]">
            <el-input
                style="width: 180px"
                placeholder="请输入密码"
                show-password
                v-model.trim="formData.password"
                clearable
            >
            </el-input>
          </el-form-item>

          <!-- 昵称字段，两种类型都可以填写 -->
          <el-form-item label="昵称" prop="nickname"
                        :rules="[{required:true,message:'请输入昵称',trigger:[ 'blur','change']}]">
            <el-input
                style="width: 180px"
                placeholder="请输入昵称"
                v-model.trim="formData.nickname"
                clearable
            >
            </el-input>
          </el-form-item>

          <!-- 店铺相关字段 -->
          <div v-if="formData.type === 'SHOP'">
            <el-form-item label="店铺名称" prop="name"
                          :rules="[{required:true,message:'请输入店铺名称',trigger:[ 'blur','change']}]">
              <el-input
                  style="width: 180px"
                  placeholder="请输入店铺名称"
                  v-model.trim="formData.name"
                  clearable
              >
              </el-input>
            </el-form-item>
            <el-form-item label="店铺资质" prop="aptitudeImgs"
                          :rules="[{required:true,message:'请上传店铺资质',trigger:[ 'blur','change']}]">
              <MyUpLoad type="imageCard" :limit="5" :files="formData.aptitudeImgs"
                        @setFiles="formData.aptitudeImgs = $event"></MyUpLoad>
            </el-form-item>
          </div>

          <!-- 操作按钮 -->
          <el-form-item label="" style="width: 100%">
            <el-space direction="vertical" alignment="left" style="width: 100%">
              <el-button @click="submitForm()" type="success" style="width: 100%">注 册</el-button>
              <router-link tag="span" :to="{path:'login'}">
                <span style="float: right">已有账号？去登录</span>
              </router-link>
            </el-space>
          </el-form-item>
        </el-form>
      </el-space>
    </el-card>
  </div>
</template>
<script setup>
import {ref} from 'vue';
import {ElMessage} from 'element-plus';
import http from "@/utils/http.js";
import MyUpLoad from "@/components/MyUpload.vue";
import router from "@/router/index.js";

const formRef = ref(null);
const formData = ref({
  type: 'USER', // 默认为用户类型
  username: '',
  nickname: '',
  avatarUrl: '',
  password: '',
  name: '', // 店铺名称
  aptitudeImgs: [] // 店铺资质图片
});

const rules = ref({
  username: [
    {required: true, message: '请输入用户名称', trigger: 'blur'},
  ],
  password: [
    {required: true, message: '请输入密码', trigger: 'blur'},
  ],
  name: [
    {required: true, message: '请输入店铺名称', trigger: 'blur'},
  ],
  aptitudeImgs: [
    {required: true, message: '请上传店铺资质', trigger: 'blur'},
  ],
});

// 提交表单逻辑
const submitForm = () => {
  formRef.value.validate((valid) => {
    if (!valid) {
      return;
    }
    http.put("/common/register", formData.value).then(res => {
      if (!res) {
        return;
      }
      http.post("/common/login", {
        username: formData.value.username,
        password: formData.value.password,
        type: formData.value.type
      }).then(loginRes => {
        if (!loginRes) {
          return;
        }
        localStorage.setItem("token", loginRes.data);
        http.get("/common/currentUser").then(userRes => {
          localStorage.setItem("currentUser", JSON.stringify(userRes.data));
          ElMessage({
            message: "注册并登录成功",
            type: "success"
          });
          if (userRes.data.type === "USER") {
            router.push({path: "/"});
          } else {
            router.push({path: "/admin"});
          }
        });
      });
    });
  });
};
</script>
<style scoped>
.main-context {
  height: 100vh; /* 使 .app 高度为视口高度 */
  background: url("../assets/login.png") no-repeat center center fixed;
  background-size: cover; /* 使用 cover 保持图片比例 */
  display: flex;
  justify-content: center;
  align-items: center;
  color: white; /* 根据背景图片调整文字颜色 */
}

.box-card {
  width: 350px;
  margin: 0 auto;
  text-align: center;
}

/* 动态切换字段的样式 */
.el-form-item {
  margin-bottom: 15px;
}
</style>
