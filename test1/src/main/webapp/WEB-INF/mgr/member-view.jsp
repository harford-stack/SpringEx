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
                    <th>아이디</th>
                    <td>{{info.userId}}</td>
                </tr>
                <tr>
                    <th>이름</th>
                    <td>{{info.name}}</td>
                </tr>
                <tr>
                    <th>닉네임</th>
                    <td>{{info.nickName}}</td>
                </tr>
                <tr>
                    <th>생년월일</th>
                    <td>{{info.cBirth}}</td>
                </tr>
                <tr>
                    <th>성별</th>
                    <td>{{info.gender}}</td>
                </tr>
                <tr>
                    <th>회원등급</th>
                    <td>{{info.status}}</td>
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
                userId : "${userId}",
                info : {}
            };
        },
        methods: {
            // 함수(메소드) - (key : function())
            fnMemberInfo: function () {
                let self = this;
                let param = {
                    userId : self.userId
                };
                $.ajax({
                    url: "/mgr/member/view.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {

                    }
                });
            }
        }, // methods
        mounted() {
            // 처음 시작할 때 실행되는 부분
            let self = this;
            self.fnMemberInfo();
        }
    });

    app.mount('#app');
</script>