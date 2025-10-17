<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <script src="/js/page-change.js"></script>
    <style>
        table, tr, td, th{
            border : 1px solid black;
            border-collapse: collapse;
            padding : 5px 10px;
            text-align: center;
        }
        th{
            background-color: burlywood;
        }
        tr:nth-child(even){
            background-color: beige;
        }
        table a {
            color: black;
            text-decoration: none;
        }
        .red-title {
            color: red !important; /* !important를 사용하여 다른 스타일에 우선하도록 합니다. */
        }
        .active {
            color : black;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <div id="app">
        <!-- html 코드는 id가 app인 태그 안에서 작업 -->
        <div>
            <select v-model="searchOption">
                <option value="all">:: 전체 ::</option>
                <option value="title">:: 제목 ::</option>
                <option value="id">:: 작성자 ::</option>
            </select>
            <input v-model="keyword">
            <button @click="fnList">검색</button>
        </div>
        <div>
            <select v-model="pageSize" @change="fnList">
                <option value="3">3개씩</option>
                <option value="5">5개씩</option>
                <option value="10">10개씩</option>
            </select>
        </div>
        <div>
            <table>
                <tr>
                    <th>선택</th>
                    <th>글번호</th>
                    <th>글제목</th>
                    <th>조회수</th>
                    <th>작성자</th>
                    <th>작성일</th>
                </tr>
                <tr v-for="item in list">
                    <td>
                        <input type="radio" :value="item.bbsNum" v-model="selectItem">
                    </td>
                    <td>{{item.bbsNum}}</td>
                    <td>
                        <a href="javascript:;" 
                           @click="fnView(item.bbsNum)" 
                           :class="{'red-title': item.hit >= 25}"
                        >
                           {{item.title}}
                        </a>
                    </td>
                    <td>{{item.hit}}</td>
                    <td>{{item.userId}}</td>
                    <td>{{item.cdate}}</td>
                </tr>
            </table>
            <div>
                <a v-if="page != 1" id="index" href="javascript:;" @click="fnMove(-1)">◀</a>
                <a @click="fnPage(num)" id="index" href="javascript:;" v-for="num in index">
                    <span :class="{active : num == page}">{{num}}</span>
                    <!-- <span v-if="num == page" class="active">{{num}}</span>
                    <span v-else>{{num}}</span> -->
                </a>
                <a v-if="page != index" id="index" href="javascript:;" @click="fnMove(1)">▶</a>
            </div>
            <div>
                <a href="/bbs/add.do"><button>글쓰기</button></a>
                <button @click="fnRemove(selectItem)">선택 삭제</button>
            </div>
        </div>
    </div>
</body>
</html>

<script>
    const app = Vue.createApp({
        data() {
            return {
                // 변수 - (key : value)
                list : [],
                selectItem : "",
                keyword : "", // 검색어
                searchOption : "all", // 검색 옵션 (기본 : 전체)
                pageSize : 3, // 한 페이지에 출력할 개수
                page : 1, // 현재 페이지
                index : 0 // 최대 페이지 값

            };
        },
        methods: {
            // 함수(메소드) - (key : function())
            fnList: function () {
                let self = this;
                let param = {
                    keyword : self.keyword,
                    searchOption : self.searchOption,
                    pageSize : self.pageSize,
                    page : (self.page-1) * self.pageSize
                };
                $.ajax({
                    url: "/bbs/list.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        console.log(data);
                        self.list = data.list;
                        self.index = Math.ceil(data.cnt / self.pageSize);
                    }
                });
            },
            fnRemove: function(bbsNum) {
                let self = this;
                let param = {
                    bbsNum : bbsNum
                };
                $.ajax({
                    url: "/bbs/delete.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        alert("삭제되었습니다");
                        self.selectItem = "";
                        self.page = 1;
                        self.fnList();
                    }
                });
            },
            fnView: function(bbsNum) {
                pageChange("/bbs/view.do", {bbsNum : bbsNum});
            },
            fnPage: function(num) {
                let self = this;
                self.page = num;
                self.fnList();
            },
            fnMove: function(move) {
                let self = this;
                self.page += move;
                self.fnList();
            }
        }, // methods
        mounted() {
            // 처음 시작할 때 실행되는 부분
            let self = this;
            self.fnList();
        }
    });

    app.mount('#app');
</script>