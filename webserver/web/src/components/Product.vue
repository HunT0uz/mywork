<template>
  <el-space direction="vertical" alignment="left"  @click="router.push('/productDetails/'+props.product.id)">
    <el-image style=" width: 100%; aspect-ratio: 1; height: auto" fit="fill"
              :src="props.product.mainImg"/>
    <el-text size="default" tag="b" line-clamp="2">
      {{ props.product.name }}
    </el-text>
    <div>
      <span style="color: red">￥{{ props.product.price }}</span>
      <div style="float: right">
        <el-space>
          <el-text class="mx-1" type="warning">已售</el-text>
          <el-text class="mx-1">{{ props.product.salesVolume }}</el-text>
        </el-space>
      </div>
    </div>
  </el-space>
</template>
<script setup>

import {defineProps, ref, toRaw} from "vue";
import request from "@/utils/http.js";
import router from "@/router/index.js";

const props = defineProps({
  product: {
    type: Object,
    default: {},
  }
});

</script>

<style scoped>

</style>
