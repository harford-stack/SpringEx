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
    </style>
</head>
<body>
    <div id="app">
        <!-- html 코드는 id가 app인 태그 안에서 작업 -->
		<div>
			<input v-model="keyword" placeholder="검색어">
			<button @click="fnInfo">검색</button>
		</div>
        <div>
            <table>
                <tr>
                    <th><input type="checkbox" @click="fnAllCheck"></th>
                    <th>학번</th>
                    <th>이름</th>
                    <th>학과</th>
                    <th>학년</th>
                    <th>성별</th>
                    <th>수정</th>
                    <th>삭제</th>
                </tr>
                <tr v-for="item in list">
                    <td>
                        <input type="checkbox" :value="item.stuNo" v-model="selectItem">
                    </td>
                    <td>{{item.stuNo}}</td>
                    <td><a href="javascript:;" @click="fnView(item.stuNo)">{{item.stuName}}</a></td>
                    <td>{{item.stuDept}}</td>
                    <td>{{item.stuGrade}}</td>
                    <td>{{item.stuGender}}</td>
                    <td><button @click="fnEdit(item.stuNo)">수정</button></td>
                    <td><button @click="fnRemove(item.stuNo)">삭제</button></td>
                </tr>
            </table>
        </div>
        <div>
            <button @click="fnAdd">추가</button>
            <button @click="fnAllRemove">선택 삭제</button>
        </div>
    </div>
</body>
</html>

<script>
    const app = Vue.createApp({
        data() {
            return {
                // 변수 - (key : value)
				keyword : "",
                list : [],
                selectItem : [],
                selectFlg : false
            };
        },
        methods: {
            // 함수(메소드) - (key : function())
            fnList: function () {
                let self = this;
                let param = {};
                $.ajax({
                    url: "stu-list.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
						console.log(data);
                        self.list = data.list;
                    }
                });
            },
            fnInfo: function () {
                let self = this;
                let param = {
					keyword : self.keyword
				};
                $.ajax({
                    url: "stu-info.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
						console.log(data);
                    }
                });
            },
            fnRemove: function(stuNo) {
                let self = this;
                let param = {
                    stuNo : stuNo
                };
                $.ajax({
                    url: "stu-delete.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
						alert("삭제되었습니다.");
                        self.fnList();
                    }
                });
            },
            fnView: function(stuNo) {
                pageChange("stu-view.do", {stuNo : stuNo});
            },
            fnAdd: function() {
                location.href="stu-add.do";
            },
            fnEdit: function(stuNo) {
                pageChange("stu-edit.do", {stuNo : stuNo});
            },
            fnAllRemove: function() {
                let self = this;
                // console.log(self.selectItem);
                var fList = JSON.stringify(self.selectItem);
                var param = {selectItem : fList};

                $.ajax({
                    url: "/stu/deleteList.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        alert("삭제되었습니다.");
                        self.fnList();
                    }
                });
            },
            fnAllCheck: function() {
                let self = this;
                self.selectFlg = !self.selectFlg;

                if(self.selectFlg) {
                    self.selectItem = [];
                    for(let i=0; i<self.list.length; i++) {
                        self.selectItem.push(self.list[i].stuNo);
                    }
                } else {
                    self.selectItem = [];
                }
                // 전체 선택 상태에서 하나라도 체크 해제되면 맨위 체크박스도 해제하는 거 해보기
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