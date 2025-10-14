<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <script src="https://code.jquery.com/jquery-3.7.1.js"
        integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <script src="/js/page-change.js"></script>
    <title>쇼핑몰 헤더</title>
    <link rel="stylesheet" href="/css/product-style.css">
</head>

<body>
    <div id="app">
        <header>
            <div class="logo">
                <img src="/img/logo.png" alt="쇼핑몰 로고">
            </div>

            <nav>
                <ul>
                    <li class="dropdown" v-for="item in menuList">
                        <a href="#" v-if="item.depth == 1" @click="fnList(item.menuNo, '')">{{item.menuName}}</a>
                        <ul class="dropdown-menu" v-if="item.cnt > 0">
                            <li v-for="subItem in menuList">
                                <a href="#" v-if="subItem.menuPart == item.menuNo" @click="fnList('', subItem.menuNo)">
                                    {{subItem.menuName}}
                                </a>
                            </li>
                        </ul>
                    </li>
                </ul>
            </nav>
            <div class="search-bar">
                <input type="text" v-model="keyword" @keyup.enter="fnList('', '')" placeholder="상품을 검색하세요...">
                <button @click="fnList('', '')">검색</button>
            </div>
            <div class="login-btn">
                <button>로그인</button>
            </div>
        </header>

        <main>
            <section class="product-list">
                <!-- 제품 항목 -->
                <div class="product-item" v-for="item in list">
                    <a href="javascript:;" @click="fnView(item.foodNo)">
                        <img :src="item.filePath" alt="제품 1">
                    </a>
                        <h3>{{item.foodName}}</h3>
                        <p>{{item.foodInfo}}</p>
                        <p class="price">₩{{item.price.toLocaleString()}}</p>
                </div>
            </section>
        </main>
    </div>
</body>
</html>
<script>
    const app = Vue.createApp({
        data() {
            return {
                list : [],
                menuList : [],
                keyword : ""
            };
        },
        methods: {
            fnLogin() {
                var self = this;
                var nparmap = {};
                $.ajax({
                    url: "login.dox",
                    dataType: "json",
                    type: "POST",
                    data: nparmap,
                    success: function (data) {
                        console.log(data);
                    }
                });
            },
            fnList: function(part, menuNo) {
                let self = this;
                let param = {
                    keyword : self.keyword,
                    menuPart : part,
                    menuNo : menuNo
                };
                $.ajax({
                    url: "/product/list.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        console.log(data);
                        self.list = data.list;
                        self.menuList = data.menuList;
                    }
                });
            },
            fnView: function(foodNo) {
                pageChange("/product/view.do", {foodNo : foodNo});
            }
        },
        mounted() {
            var self = this;
            self.fnList();
        }
    });
    app.mount('#app');
</script>