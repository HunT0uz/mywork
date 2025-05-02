import {createRouter, createWebHistory} from 'vue-router'
import AdminLayout from "@/views/layout/AdminLayout.vue";
import FrontLayout from "@/views/layout/FrontLayout.vue";
import tools from "@/utils/tools.js";

const router = createRouter({
    history: createWebHistory(),
    routes: getRoutes()
})

function getRoutes() {
    let defaultRoutes = [
        {
            path:'/',
            name:'front',
            component: FrontLayout,
            redirect: '/index',
            children: [
                {
                    path:'index',
                    name:'index',
                    component: () => import('../views/front/Index.vue')
                },
                {
                    path: 'productDetails/:id',
                    name: 'front-productDetails',
                    component: () => import('../views/front/ProductDetails.vue')
                },
                {
                    path: 'personalCenter',
                    name: 'front-personalCenter',
                    component: () => import('../views/front/PersonalCenter.vue')
                },
                {
                    path: 'personalCenter/shippingAddress',
                    name: 'front-shippingAddress',
                    component: () => import('../views/front/personalCenter/ShippingAddress.vue')
                },
                {
                    path: 'personalCenter/productCollect',
                    name: 'front-productCollect',
                    component: () => import('../views/front/personalCenter/ProductCollect.vue')
                },
                {
                    path: 'personalCenter/productBrowsingHistory',
                    name: 'front-productBrowsingHistory',
                    component: () => import('../views/front/personalCenter/ProductBrowsingHistory.vue')
                },
                {
                    path: 'personalCenter/shopCollect',
                    name: 'front-shopCollect',
                    component: () => import('../views/front/personalCenter/ShopCollect.vue')
                },
                {
                    path: 'shop',
                    name: 'front-shop',
                    component: () => import('../components/Shop.vue')
                },
                {
                    path: 'productOrderEvaluate',
                    name: 'front-productOrderEvaluate',
                    component: () => import('../views/front/ProductOrderEvaluate.vue')
                },
                {
                    path: 'personalCenter',
                    name: 'front-personalCenter',
                    component: () => import('../views/front/PersonalCenter.vue')
                },
                {
                    path: 'productList',
                    name: 'front-productList',
                    component: () => import('../views/front/ProductList.vue')
                },
                {
                    path: 'shoppingCart',
                    name: 'front-shoppingCart',
                    component: () => import('../views/front/ShoppingCart.vue')
                },
                {
                    path: 'productOrder',
                    name: 'front-ProductOrder',
                    component: () => import('../views/front/ProductOrder.vue')
                }
            ]
        },
        {
            path: '/admin',
            name: 'admin',
            component: AdminLayout,
            children: [
                {
                    path: 'admin',
                    name: 'Admin',
                    component: () => import('../views/admin/AdminManage.vue')
                },
                {
                    path: 'user',
                    name: 'admin-user',
                    component: () => import('../views/user/UserManage.vue')
                },
                {
                    path: 'shop',
                    name: 'admin-shop',
                    component: () => import('../views/admin/ShopManage.vue')
                },
                {
                    path: 'productType',
                    name: 'admin-productType',
                    component: () => import('../views/admin/ProductTypeManage.vue')
                },
                {
                    path: 'productCollect',
                    name: 'admin-productCollect',
                    component: () => import('../views/admin/ProductCollectManage.vue')
                },
                {
                    path: 'productBrowsingHistory',
                    name: 'admin-productBrowsingHistory',
                    component: () => import('../views/admin/ProductBrowsingHistoryManage.vue')
                },
                {
                    path: 'product',
                    name: 'admin-product',
                    component: () => import('../views/admin/ProductManage.vue')
                },
                {
                    path: 'shippingAddress',
                    name: 'admin-shippingAddress',
                    component: () => import('../views/admin/ShippingAddressManage.vue')
                },
                {
                    path: 'productOrder',
                    name: 'admin-productOrder',
                    component: () => import('../views/admin/ProductOrderManage.vue')
                },
                {
                    path: 'productOrderEvaluate',
                    name: 'admin-productOrderEvaluate',
                    component: () => import('../views/admin/ProductOrderEvaluateManage.vue')
                },
                {
                    path: 'shopCollect',
                    name: 'admin-shopCollect',
                    component: () => import('../views/admin/ShopCollectManage.vue')
                },
                {
                    path: 'advertising',
                    name: 'admin-advertising',
                    component: () => import('../views/admin/AdvertisingManage.vue')
                },
                {
                    path: 'slideshow',
                    name: 'admin-slideshow',
                    component: () =>
                        import ('../views/admin/SlideshowManage.vue')
                },
                {
                    path: "editCurrentUser",
                    name: "editCurrentUser",
                    component: () => import('../views/EditCurrentUser.vue')
                },
                {
                    path: "editPassword",
                    name: "editPassword",
                    component: () => import('../views/EditPassword.vue')
                },
                {
                    path: "",
                    name: "admin-home",
                    component: () =>
                        import ('../views/admin/Home.vue')
                }
            ]
        },
        {
            path: "/login",
            name: "login",
            component: () => import('../views/Login.vue')
        },
        {
            path: "/register",
            name: "register",
            component: () => import('../views/Register.vue')
        },
        {
            path: "/retrievePassword",
            name: "front-retrievePassword",
            component: () => import('../views/RetrievePassword.vue')
        },
        {
            path: "/balanceInfo",
            name: "front-balanceInfo",
            component: () => import('../views/BalanceInfo.vue')
        }
    ];
    
    defaultRoutes.push({
        path: '/:pathMatch(.*)*',
        name: 'NotFound',
        meta: {
            name: ''
        },
        component: () => import('../views/404.vue')
    });
    
    return defaultRoutes;
}
// 导出路由实例
export default router
