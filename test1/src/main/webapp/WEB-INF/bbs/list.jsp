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
    </style>
</head>
<body>
    <div id="app">
        <!-- html 코드는 id가 app인 태그 안에서 작업 -->
        <div>
            <table>
                <tr>
                    <th>삭제</th>
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
                selectItem : ""
            };
        },
        methods: {
            // 함수(메소드) - (key : function())
            fnList: function () {
                let self = this;
                let param = {};
                $.ajax({
                    url: "/bbs/list.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        console.log(data);
                        self.list = data.list;
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
                        self.fnList();
                    }
                });
            },
            fnView: function(bbsNum) {
                pageChange("/bbs/view.do", {bbsNum : bbsNum});
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