<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
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
    </style>
</head>
<body>
    <div id="app">
        <!-- html 코드는 id가 app인 태그 안에서 작업 -->
        <div>
            <table>
                <tr>
                    <th>음식 이름</th>
                    <td>{{info.foodName}}</td>
                </tr>
                <tr>
                    <th>음식 설명</th>
                    <td>{{info.foodInfo}}</td>
                </tr>
                <tr>
                    <th>음식 가격</th>
                    <td>₩{{info.price}}</td>
                </tr>
                <tr>
                    <th>음식 사진</th>
                    <td>
                        <img v-for="item in fileList" :src="item.filePath">
                    </td>
                </tr>
            </table>
        </div>
    </div>
</body>
</html>

<script>
    const app = Vue.createApp({
        data() {
            return {
                // 변수 - (key : value)
                foodNo : "${foodNo}",
                info : {},
                fileList : []
            };
        },
        methods: {
            // 함수(메소드) - (key : function())
            fnProductInfo: function () {
                let self = this;
                let param = {
                    foodNo : self.foodNo
                };
                $.ajax({
                    url: "/product/view.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        console.log(data);
                        self.info = data.info;
                        self.fileList = data.fileList;
                    }
                });
            }
        }, // methods
        mounted() {
            // 처음 시작할 때 실행되는 부분
            let self = this;
            self.fnProductInfo();
        }
    });

    app.mount('#app');
</script>