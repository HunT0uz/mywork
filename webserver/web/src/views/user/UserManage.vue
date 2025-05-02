<template>
  <div>
    <el-space direction="vertical" alignment="left" style="width: 100%">
      <el-card>
        <el-form ref="searchFormComponents" :model="searchForm" inline>
          <el-form-item label="用户名" prop="username">
            <el-input v-model="searchForm.username" clearable></el-input>
          </el-form-item>
          <el-form-item label="电话" prop="tel">
            <el-input v-model="searchForm.tel" clearable></el-input>
          </el-form-item>
          <el-form-item label="状态" prop="status">
            <el-select v-model="searchForm.status" placeholder="请选择" clearable filterable style="width: 150px">
              <el-option :label="item" v-for="item in statusList" :key="item" :value="item"></el-option>
            </el-select>
          </el-form-item>
          <el-form-item>
            <el-button type="primary" :icon="Search" @click="search">搜索</el-button>
            <el-button type="" :icon="Refresh" @click="resetSearch">重置</el-button>
          </el-form-item>
        </el-form>
        <el-space>
          <el-button type="primary" :icon="Plus" @click="add">新增</el-button>
          <el-button type="danger" :icon="Delete" @click="batchDelete(null)" :disabled="selectionRows.length<=0">批量删除</el-button>
        </el-space>
      </el-card>
      <el-card>
        <el-table :data="listData"
                  @selection-change="selectionChange"
                  ref="tableComponents"
                  tooltip-effect="dark"
                  border
                  style="width: 100%">
          <el-table-column type="selection" width="55" />
          <el-table-column property="username" label="用户名" />
          <el-table-column property="nickname" label="昵称"  />
          <el-table-column property="avatarUrl" label="头像"  >
            <template #default="scope">
              <el-image v-if="scope.row.avatarUrl"
                        style="width: 100px;height: 100px"
                        :src="scope.row.avatarUrl"
                        :preview-src-list="[scope.row.avatarUrl]"
                        :preview-teleported="true"
              ></el-image>
            </template>
          </el-table-column>
          <el-table-column property="tel" label="电话" />
          <el-table-column property="email" label="邮箱"  />
          <el-table-column property="status" label="状态"  />
          <el-table-column property="createTime" label="创建时间"  />

          <el-table-column fixed="right" label="操作" width="200">
            <template #default="scope">
              <el-button type="primary" :icon="Edit" @click="edit(scope.row)">编辑</el-button>
              <el-button type="danger" :icon="Delete" @click="deleteOne(scope.row)">删除</el-button>

            </template>
          </el-table-column>
        </el-table>
        <div style="margin-top: 20px;">
          <el-pagination
              @current-change="currentChange"
              @size-change="sizeChange"
              :page-size="pageInfo.pageSize"
              :current-page="pageInfo.pageNum"
              background
              layout="total,sizes,prev,pager,next"
              :total="pageInfo.total"
          />
        </div>
      </el-card>

    </el-space>

    <el-dialog
        v-model="dialogOpen"
        v-if="dialogOpen"
        :title="formData.id?'编辑':'新增'"
        width="500"
    >

      <el-form ref="formRef" :model="formData" label-width="100">
        <el-form-item label="用户名" prop="username"
                      :rules="[{required:true,message:'不能为空',trigger:['blur','change']}]">
          <el-input v-model="formData.username"></el-input>
        </el-form-item>
        <el-form-item label="昵称" prop="nickname"
                      :rules="[{required:true,message:'不能为空',trigger:['blur','change']}]">
          <el-input v-model="formData.nickname"></el-input>
        </el-form-item>
        <el-form-item label="头像" prop="avatarUrl"
                      :rules="[{required:true,message:'不能为空',trigger:['blur','change']}]">
          <MyUpload type="imageCard" :limit="1" :files="formData.avatarUrl"
                    @setFiles="formData.avatarUrl = $event" v-if="dialogOpen"
          ></MyUpload>
        </el-form-item>
        <el-form-item label="电话" prop="tel"
                      :rules="[{required:true,message:'不能为空',trigger:['blur','change']}]">
          <el-input v-model="formData.tel"></el-input>
        </el-form-item>
        <el-form-item label="邮箱" prop="email"
                      :rules="[{required:true,message:'不能为空',trigger:['blur','change']}]">
          <el-input v-model="formData.email"></el-input>
        </el-form-item>
        <el-form-item label="状态" prop="status"
                      :rules="[{required:true,message:'不能为空',trigger:[ 'blur','change']}]">
          <el-radio-group v-model="formData.status">
            <el-radio v-for="item in statusList" :key="item" :label="item">{{item}}</el-radio>

          </el-radio-group>
        </el-form-item>
      </el-form>

      <template #footer>
        <div class="dialog-footer">
          <el-button type="primary" :icon="Check" @click="submit">提交</el-button>
          <el-button :icon="Close" @click="closeDialog">取消</el-button>

        </div>
      </template>
    </el-dialog>

  </div>
</template>
<script setup>

import {ref, toRaw} from "vue";
import {Search,Refresh,Plus,Delete,Edit,Check,Close} from '@element-plus/icons-vue'

import request from "@/utils/http.js"

import MyUpload from "@/components/MyUpload.vue"
import {ElMessage, ElMessageBox} from "element-plus";

/**
 * 分页对象
 * @type {Ref<UnwrapRef<{total: number, pageSize: number, pageNum: number}>, UnwrapRef<{total: number, pageSize: number, pageNum: number}> | {total: number, pageSize: number, pageNum: number}>}
 */

const pageInfo = ref({
  //当前页
  pageNum:1,
  //每页有多少条
  pageSize:10,
  //总条数
  total:0
})


const searchFormComponents = ref()

const searchForm = ref({
  username:undefined,
  tel:undefined,
  status:undefined,
})

const listData = ref([])

//定义用户状态
const statusList = ref(['启用','禁用'])

//新增编辑
const formData = ref({})

//控制弹窗开关
const dialogOpen = ref(false)

const formRef = ref()

//调用
getPageList()

function getPageList(){
  let data = Object.assign(toRaw(searchForm.value),toRaw(pageInfo.value))
  request.get("/user/page",{
    params:data
  }).then(res => {
    //获取列表
    console.log(res)
    listData.value = res.data.list
    //获取总记录条数
    pageInfo.value.total = res.data.total
  })
}


/**
 * 搜索
 */
function search(){
  //用户点击搜索，分页重置到第一页
  pageInfo.value.pageNum = 1
  //调用分页方法
  getPageList()

}

/**
 * 重置搜索
 */
function resetSearch(){
  searchFormComponents.value.resetFields()
  getPageList()
}

/**
 * 新增
 */
function add(){
  //清空值
  formData.value = {}
  //点击按钮 打开弹窗
  dialogOpen.value = true
}

/**
 * 编辑
 * @param row
 */
function edit(row){
  formData.value = Object.assign({},row)
  dialogOpen.value = true

}

/**
 * 关闭弹窗
 */
function closeDialog(){
  dialogOpen.value = false
}

/**
 * 提交数据
 */
function submit(){
  console.log(formData.value)

  formRef.value.validate((valid) => {
    if(!valid){
      ElMessage({
        message:"验证失败，请检查表单",
        type:'warning'
      })

      return
    }
    const requestMethod = formData.value.id ? request.put : request.post
    const url = formData.value.id ? "/user/update":"/user/add"

    requestMethod(url,formData.value).then(res => {
      if(!res){
        return
      }
      dialogOpen.value = false
      ElMessage({
        message:"操作成功",
        type:'success'
      })
      //重新获取列表
      getPageList()
    })

  })
}

//获取选中的数据
const selectionRows = ref([])

const tableComponents = ref()

/**
 * 批量删除
 */
function batchDelete(rows){
  if(!rows){
    //如果没有传入rows，则使用已经被选中的数据
    rows = selectionRows.value
  }
  //提取要删除的id列表
  const ids = rows.map(item => item.id)
  ElMessageBox.confirm(
      `此操作将永久删除ID为[${ids}]的数据，是否继续？`,
      '提示',
      {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning',
        center: true,
      }
  )
      .then(() => {

        //发送删除请求
        request.delete("/user/delBatch",{data:ids}).then(()=>{
          ElMessage({
            type: 'success',
            message: '删除成功',
          })

          //重新获取数据
          getPageList()
        })

      })
      .catch(() => {
        ElMessage({
          type: 'info',
          message: '取消删除',
        })
        tableComponents.value.clearSelection()
      })
}


/**
 * 单选删除
 */
function deleteOne(row){
  batchDelete([row])
}

/**
 * 选中
 */
function selectionChange(rows){
  selectionRows.value = rows
}

/**
 * 选择分页
 * @param pageNum
 */
function currentChange(pageNum){
  pageInfo.value.pageNum = pageNum
  getPageList()
}

/**
 * 改变分页数量
 * @param pageSize
 */
function sizeChange(pageSize){
  pageInfo.value.pageSize = pageSize
  getPageList()
}

</script>
