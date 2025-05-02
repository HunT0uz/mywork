<template>
  <div style="width: 60%;margin: 0 auto" v-if="info.id">
    <el-card v-if="info.id">
      <el-row :gutter="20">
        <el-col :span="8">
          <el-carousel indicator-position="outside">
            <el-carousel-item v-for="item in info.imgList.split(',')" :key="item">
              <el-image :src="item" style="height: 300px; height: 300px;"/>
            </el-carousel-item>
          </el-carousel>
        </el-col>
        <el-col :span="16">
          <el-space direction="vertical" alignment="left" style="width: 100%">
            <div>
              <H2>{{ info.name }} </H2>
            </div>
            <div style="font-size: 24px">
              <span>价格:</span>
              <span style="color: red">￥{{ info.price }} </span>
            </div>
            <div>
              <el-space size="large">
                <el-statistic title="库存" :value="info.stock"/>
                <el-statistic title="销量" :value="info.salesVolume"/>
              </el-space>
            </div>
            <div>
              <el-space direction="vertical" alignment="left">
                <el-space spacer="|">
                  <el-tag type="success">准时达</el-tag>
                  <span>承诺24小时内发货，超时必赔</span>
                </el-space>
                <el-space spacer="|">
                <span>
                    <el-icon :size="18" color="green"><CircleCheck/></el-icon> 7天价保</span>
                  <span>买贵双倍赔</span>
                </el-space>

                <el-space spacer="|">
                  <span>包邮</span>
                  <span>免费上门退换</span>
                  <span>破损包退换</span>
                  <span>上门换新</span>
                </el-space>
              </el-space>
            </div>
            <div>
              <el-button type="danger" @click="buy">立即购买</el-button>
              <el-button type="info" @click="removeCollect" v-if="info.productCollectId">取消收藏</el-button>
              <el-button type="warning" @click="addCollect" v-if="!info.productCollectId">收藏</el-button>
              <el-button type="primary" @click="addShoppingCart">加入购物车</el-button>
            </div>
          </el-space>
        </el-col>
      </el-row>

      <el-divider></el-divider>
      <Shop :shopId="info.shopId"></Shop>

      <el-divider></el-divider>
      <el-tabs v-model="activeName">
        <el-tab-pane label="图文详情" name="first">
          <div class="content" v-html="info.intro" style="  margin: 0 auto; width: 75%;"></div>
        </el-tab-pane>
        <el-tab-pane label="评价" name="second">
          <ProductOrderEvaluate :productId="info.id"/>
        </el-tab-pane>
      </el-tabs>
    </el-card>
    <el-dialog
        v-model="buyDialogOpen"
        v-if="buyDialogOpen"
        title="填写订单信息"
        width="500"
    >
      <el-form ref="buyFormRef" :model="productOrder" label-width="100px">
        <slot name="content">
          <el-form-item label="收货地址" prop="shippingAddressId"
                        :rules="[{required:true,message:'请输入选择地址',trigger:[ 'blur','change']}]">
            <el-select v-model="productOrder.shippingAddressId" placeholder="请选择" filterable>
              <el-option :label="item.name+'_'+item.tel+'_'+item.address" :value="item.id" :key="item.id"
                         v-for="item in shippingAddressList"></el-option>
            </el-select>
          </el-form-item>
          <el-form-item label="数量" prop="quantity"
                        :rules="[{required:true,message:'请输入购买数量',trigger:[ 'blur','change']}]">
            <el-input-number v-model="productOrder.quantity" :min="1"/>
          </el-form-item>
          <el-form-item label="备注" prop="remark">
            <el-input type="textarea" :rows="5" v-model="productOrder.remark"></el-input>
          </el-form-item>
        </slot>
      </el-form>
      <template #footer>
        <div class="dialog-footer">
          <el-button type="primary" @click="buySubmit" :icon="Check">提交</el-button>
          <el-button @click="buyDialogOpen=false" :icon="Close">取消</el-button>
        </div>
      </template>
    </el-dialog>


  </div>
</template>
<script setup>
import request from "@/utils/http.js";
import {ref, toRaw} from "vue";
import {useRoute} from "vue-router";
import {Check, Close} from "@element-plus/icons-vue";
import {ElMessage} from "element-plus";
import router from "@/router/index.js";
import ProductOrderEvaluate from "@/components/ProductOrderEvaluate.vue";
import Shop from "@/components/Shop.vue";


const route = useRoute()
const id = ref(route.params.id)
const info = ref({});

getInfo()

function getInfo() {
  request.get("/product/selectById/" + id.value).then(res => {
    info.value = res.data;
  })
}


const shippingAddressList = ref([])
getShippingAddressList();

async function getShippingAddressList() {
  let data = {
    pageNum: 1,
    pageSize: 100
  }
  request.get("/shippingAddress/page", {
    params: data
  }).then(res => {
    shippingAddressList.value = res.data.list;
  })
}

addBrowsingHistory();

/**
 * 添加浏览历史
 */
function addBrowsingHistory() {
  request.post("/productBrowsingHistory/add", {productId: id.value}).then(res => {

  })
}

function addCollect() {
  request.post("/productCollect/add", {productId: id.value}).then(res => {
    info.value.productCollectId = res.data.id
  })
}


function removeCollect() {
  let ids = [
    info.value.productCollectId
  ]
  request.delete("/productCollect/delBatch", {data: ids}).then(res => {
    info.value.productCollectId = null
  })
}


function addShoppingCart() {
  request.post("/shoppingCart/add", {productId: id.value, quantity: 1}).then(res => {
    ElMessage({
      message: "添加成功",
      type: 'success'
    });
  })
}


const buyDialogOpen = ref(false)
const productOrder = ref({})
const buyFormRef = ref()

function buy() {
  productOrder.value = {}
  productOrder.value.quantity = 1
  buyDialogOpen.value = true
}

function buySubmit() {
  buyFormRef.value.validate((valid) => {
    if (!valid) {
      ElMessage({
        message: "验证失败，请检查表单!",
        type: 'warning'
      });
      return
    }
    let shippingAddress = shippingAddressList.value.find(item => item.id == productOrder.value.shippingAddressId);
    productOrder.value.consigneeName = shippingAddress.name;
    productOrder.value.consigneeTel = shippingAddress.tel;
    productOrder.value.consigneeAddress = shippingAddress.address;
    productOrder.value.productId = id.value;
    request.post("/productOrder/add", productOrder.value).then(res => {
      if (!res) {
        return
      }
      buyDialogOpen.value = false
      ElMessage({
        message: "操作成功",
        type: 'success'
      });
      router.push("/productOrder")
    })
  })
}

const activeName = ref('first')


</script>

<style scoped>
/* 使用 ::v-deep 穿透作用域 */
::v-deep .content img {
  width: 100%;
}
</style>

