<template>
  <div style="width: 60%;margin: 0 auto;">
    <el-card>
      <el-space direction="vertical" alignment="left" style="width: 100%">
        <el-table ref="tableComponents"
                  :data="listData"
                  tooltip-effect="dark"
                  style="width: 100%"
                  @selection-change="selectionChange">
          <el-table-column type="selection" width="40"></el-table-column>
          <el-table-column prop="id" label="">
            <template #default="scope">
              <el-space size="large">
                <el-image style=" width: 80px;height: 80px;" fit="fill"
                          :src="scope.row.productMainImg"
                />
                <el-space direction="vertical" alignment="left">
                  <H3>
                    {{ scope.row.productName }}
                  </H3>
                </el-space>
              </el-space>
            </template>
          </el-table-column>
          <el-table-column prop="price" label="" width="200">
            <template #default="scope">
              <span style="color: red;font-size: 16px">￥{{ scope.row.quantity * scope.row.productPrice }} </span>
            </template>
          </el-table-column>
          <el-table-column fixed="right" prop="quantity" label="" width="200">
            <template #default="scope">
              <el-space size="large">
                <el-input-number v-model="scope.row.quantity" @change="handleQuantityChange(scope.row)" size="default"
                                 style="width: 120px"/>
                <el-button link type="danger" @click="deleteOne(scope.$index, scope.row)">删除</el-button>
              </el-space>
            </template>
          </el-table-column>
        </el-table>
        <div style="text-align: right">
          <el-space>
            <el-tag type="primary">结算后，购物车会自动清除</el-tag>
            <span>合计</span>
            <span style="color: red;font-size: 16px">￥{{ totalPrice }}</span>
            <el-button type="danger" @click="buy" :disabled="selectionRows.length<=0">结算</el-button>
          </el-space>
        </div>

      </el-space>
    </el-card>
  </div>
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
        <el-form-item label="备注" prop="remark">
          <el-input type="textarea" :rows="5" v-model="productOrder.remark"></el-input>
        </el-form-item>
      </slot>
    </el-form>
    <template #footer>
      <div class="dialog-footer">
        <el-button type="primary" @click="createOrder" :icon="Check">提交</el-button>
        <el-button @click="buyDialogOpen=false" :icon="Close">取消</el-button>
      </div>
    </template>
  </el-dialog>
</template>

<script setup>
import request from "@/utils/http.js";
import {Check, Close, Delete, Edit, Refresh, Plus, Search} from '@element-plus/icons-vue'
import {computed, ref, toRaw} from "vue";
import {ElMessage, ElMessageBox} from "element-plus";
import router from "@/router/index.js";

const tableComponents = ref();
const listData = ref([]);
const pageInfo = ref({
  //当前页
  pageNum: 1,
  //分页大小
  pageSize: 10,
});

getPageList()

/**
 * 获取分页数据
 */
function getPageList() {
  request.get("/shoppingCart/page", {
    params: pageInfo.value
  }).then(res => {
    listData.value = res.data.list
  })
}

const selectionRows = ref([]);

/**
 * 多选
 * @param rows
 */
function selectionChange(rows) {
  selectionRows.value = rows
}

/**
 * 单个删除
 * @param index
 * @param row
 */
function deleteOne(index, row) {
  batchDelete([row])
}

/**
 * 批量删除
 * @param rows
 */
function batchDelete(rows) {
  if (!rows) {
    rows = selectionRows.value;
  }
  let ids = rows.map(item => item.id);
  ElMessageBox.confirm(`此操作将永久删除ID为[${ids}]的数据, 是否继续?`, '提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning',
    center: true
  }).then(() => {
    request.delete("/shoppingCart/delBatch", {data: ids}).then(res => {
      if (!res) {
        return
      }
      ElMessage({
        message: "操作成功",
        type: 'success'
      });
      getPageList()
    })
  }).catch(() => {
    ElMessage({
      type: 'info',
      message: '已取消删除'
    });
    tableComponents.value.clearSelection();
  });
}

function handleQuantityChange(row) {
  //更新
  request.put("/shoppingCart/update", row).then(res => {
  })
}


const totalPrice = computed(() => {
  let totalPrice = 0;
  selectionRows.value.forEach(item => {
    totalPrice += item.quantity * item.productPrice;
  })
  return totalPrice;
});


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


const buyDialogOpen = ref(false)
const productOrder = ref({})
const buyFormRef = ref()

function buy() {
  productOrder.value = {}
  productOrder.value.ids = selectionRows.value.map(item => item.id);
  buyDialogOpen.value = true
}

function createOrder() {
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
    request.post("/shoppingCart/createOrder", productOrder.value).then(res => {
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

</script>

<style scoped>

</style>

