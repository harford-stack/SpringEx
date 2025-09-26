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
                    <th>학번</th>
                    <td><input v-model="stuNo"></td>
                </tr>
                <tr>
                    <th>이름</th>
                    <td><input v-model="stuName"></td>
                </tr>
                <tr>
                    <th>학과</th>
                    <td><input v-model="stuDept"></td>
                </tr>
                <tr>
                    <th>학년</th>
                    <td><input v-model="stuGrade"></td>
                </tr>
                <tr>
                    <th>성별</th>
                    <td><input v-model="stuGender"></td>
                </tr>
            </table>
            <div>
                <button @click="fnAdd">저장</button>
                <button @click="fnBack">되돌아가기</button>
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
                stuNo : "",
                stuName : "",
                stuDept : "",
                stuGrade : "",
                stuGender : ""
            };
        },
        methods: {
            // 함수(메소드) - (key : function())
            fnAdd: function () {
                let self = this;
                let param = {
                    stuNo : self.stuNo,
                    stuName : self.stuName,
                    stuDept : self.stuDept,
                    stuGrade : self.stuGrade,
                    stuGender : self.stuGender
                };
                $.ajax({
                    url: "stu-add.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        alert("등록되었습니다");
                        self.fnBack();
                    }
                });
            },
            fnBack: function() {
                location.href="stu-list.do";
            }
        }, // methods
        mounted() {
            // 처음 시작할 때 실행되는 부분
            let self = this;
        }
    });

    app.mount('#app');
</script>