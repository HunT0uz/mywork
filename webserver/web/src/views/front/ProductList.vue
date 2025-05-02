<template>


  <div style="width: 75%;margin: 0 auto;  display: flex;height: 100vh;background-color:white;">

    <div class="left">
      <el-tabs tab-position="left" v-model="searchForm.productTypeId" @tab-change="getPageList">
        <el-tab-pane :label="item.name" :name="item.id" v-for="item in productTypeList"></el-tab-pane>
      </el-tabs>
    </div>
    <div class="right">
      <el-space direction="vertical" alignment="left" style="width: 100%">
        <el-card v-if="shopId" style="margin-bottom: 15px">
          <Shop :shopId="shopId"></Shop>
        </el-card>
        <el-space>
          <el-input v-model="searchForm.name" style="width: 500px" placeholder="请输入你感兴趣的商品" size="large"
                    clearable/>
          <el-button type="primary" icon="Search" @click="search"
                     style="background-color: #ff5000;border-color: #ff5000" size="large">搜索
          </el-button>
        </el-space>

        <el-divider></el-divider>
        <el-row :gutter="20" style="width: 100%">
          <el-col :span="4" v-for="(item,index) in listData"
                  :style="index>5 ? { marginTop: '20px',cursor: 'pointer' } : 'cursor: pointer'">
            <Product :product="item"></Product>
          </el-col>
        </el-row>
        <el-divider></el-divider>
        <el-pagination
            @current-change="currentChange"
            @size-change="sizeChange"
            :page-size="pageInfo.pageSize"
            :current-page="pageInfo.currentPage"
            background
            layout="total,sizes, prev, pager, next"
            :total="pageInfo.total">
        </el-pagination>

      </el-space>
    </div>
  </div>
</template>

<script setup>
import request from "@/utils/http.js";
import {Check, Close, Delete, Edit, Refresh, Plus, Search} from '@element-plus/icons-vue'
import {ref, toRaw} from "vue";
import {ElMessage, ElMessageBox} from "element-plus";
import MyEditor from "@/components/MyEditor.vue";
import MyUpLoad from "@/components/MyUpload.vue";
import router from "@/router/index.js";
import {useRoute} from "vue-router";
import Shop from "@/components/Shop.vue";
import Product from "@/components/Product.vue";


const searchFormComponents = ref();
const tableComponents = ref();
const listData = ref([]);
const pageInfo = ref({
  //当前页
  pageNum: 1,
  //分页大小
  pageSize: 24,
  //总条数
  total: 0
});
const searchForm = ref({
  name: undefined,
  productTypeId: ''
});

const route = useRoute()
//店铺详情需要店铺的id
const shopId = ref(null)
if (route.query.shopId) {
  shopId.value = route.query.shopId
  searchForm.value.shopId = route.query.shopId
}

if (route.query.name) {
  searchForm.value.name = route.query.name
}

const productTypeList = ref([])

getProductTypeList()

function getProductTypeList() {
  request.get("/productType/list").then(res => {
    productTypeList.value = res.data;
    productTypeList.value.unshift({id: '', name: '全部'})
  })
}


getPageList()

/**
 * 获取分页数据
 */
function getPageList() {
  let data = Object.assign(toRaw(searchForm.value), toRaw(pageInfo.value))
  request.get("/product/page", {
    params: data
  }).then(res => {
    listData.value = res.data.list
    pageInfo.value.total = res.data.total
  })
}

/**
 * 选择分页
 * @param e
 */
function currentChange(e) {
  pageInfo.value.pageNum = e
  getPageList()
}

/**
 * 改变分页数量
 * @param e
 */
function sizeChange(e) {
  pageInfo.value.pageSize = e
  getPageList()
  console.log(e)
}

/**
 * 搜索
 */
function search() {
  pageInfo.value.pageNum = 1
  getPageList()
}


</script>

<style scoped>
.left {
  padding: 20px;
}

.right {
  flex: 1;
  padding-top: 20px;
  padding-right: 20px;
}
</style>

