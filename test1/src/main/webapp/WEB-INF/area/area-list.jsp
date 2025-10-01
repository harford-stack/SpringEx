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
        tr, td, th {
            width : 120px;
            height: 25px;
        }
        tr:nth-child(even){
            background-color: beige;
        }
        #index {
            margin-right: 5px;
            text-decoration: none;
            color : black;
        }
        .active {
            color : red;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <div id="app">
        <!-- html 코드는 id가 app인 태그 안에서 작업 -->
        <!-- <div>
            <select v-model="pageSize" @change="fnList">
                <option value="5">5개씩</option>
                <option value="10">10개씩</option>
                <option value="20">20개씩</option>
            </select>
        </div> -->

        <div>
            도 / 특별시 : 
            <select v-model="si" @change="fnList">
                <option value="">:: 전체 ::</option>
                <option :value="item.si" v-for="item in siList">{{item.si}}</option>
            </select>
        </div>

        <div>
            <table>
                <tr>
                    <th>도, 특별시</th>
                    <th>구</th>
                    <th>동</th>
                </tr>
                <tr v-for="item in list">
                    <td>{{item.si}}</td>
                    <td>{{item.gu}}</td>
                    <td>{{item.dong}}</td>
                </tr>
            </table>
            <div>
                <!-- 맨 처음 페이지로 이동 -->
                <a v-if="page !== 1" id="index" href="javascript:;" @click="fnGoToFirstPage()">⏪</a>
                
                <!-- 이전 페이지 그룹으로 이동 -->
                <!-- computed 대신 methods 호출 -->
                <a v-if="checkHasPrevGroup()" id="index" href="javascript:;" @click="fnMoveGroup(-1)">◀️</a>
                
                <!-- 페이지 번호 표시 -->
                <!-- computed 대신 methods 호출 -->
                <a @click="fnPage(num)" id="index" href="javascript:;" v-for="num in getPageNumbers()" :key="num">
                    <span :class="{active : num == page}">{{num}}</span>
                </a>
                
                <!-- 다음 페이지 그룹으로 이동 -->
                <!-- computed 대신 methods 호출 -->
                <a v-if="checkHasNextGroup()" id="index" href="javascript:;" @click="fnMoveGroup(1)">▶️</a>
                
                <!-- 맨 마지막 페이지로 이동 -->
                <a v-if="page !== index" id="index" href="javascript:;" @click="fnGoToLastPage()">⏩</a>
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
                pageSize : 20, // 한 페이지에 출력할 개수
                page : 1, // 현재 페이지
                index : 0, // 최대 페이지 값
                siList : [],
                si : "", // 선택한 시(도)의 값
                pageGroupSize: 10, // 한 번에 표시할 페이지 번호 개수
                currentPageGroup: 1 // 현재 페이지 그룹
            };
        },
        methods: {
            // 함수(메소드) - (key : function())
            fnList: function () {
                let self = this;
                let param = {
                    pageSize : self.pageSize,
                    page : (self.page-1) * self.pageSize,
                    si : self.si
                };
                $.ajax({
                    url: "/area/list.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        console.log(data);
                        self.list = data.list;
                        self.index = Math.ceil(data.cnt / self.pageSize);
                        // 현재 페이지 그룹 업데이트 (만약 현재 페이지가 변경되었을 경우)
                        self.currentPageGroup = Math.ceil(self.page / self.pageGroupSize);
                    }
                });
            },
            fnPage: function(num) {
                let self = this;
                self.page = num;
                self.fnList();
                // 페이지 그룹 업데이트
                self.currentPageGroup = Math.ceil(num / self.pageGroupSize);
            },
            // fnMove: function(move) {
            //     let self = this;
            //     self.page += move;
            //     self.fnList();
            // },
            fnSiList: function () {
                let self = this;
                let param = {
                };
                $.ajax({
                    url: "/area/si.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        self.siList = data.list;
                    }
                });
            },
            // 페이지 그룹 이동 함수
            fnMoveGroup: function(move) {
                let self = this;
                // 이동할 그룹의 첫 페이지 계산
                let targetPageGroup = self.currentPageGroup + move;

                // 유효성 검사
                if (targetPageGroup < 1) targetPageGroup = 1;
                const maxPageGroup = Math.ceil(self.index / self.pageGroupSize);
                if (targetPageGroup > maxPageGroup) targetPageGroup = maxPageGroup;
                
                self.currentPageGroup = targetPageGroup;
                self.page = (self.currentPageGroup - 1) * self.pageGroupSize + 1;

                self.fnList();
            },
            // 맨 처음 페이지로 이동
            fnGoToFirstPage: function() {
                let self = this;
                self.page = 1;
                self.currentPageGroup = 1; // 맨 처음 페이지는 항상 첫 번째 그룹에 속합니다.
                self.fnList();
            },
            // 맨 마지막 페이지로 이동
            fnGoToLastPage: function() {
                let self = this;
                self.page = self.index; // index는 총 페이지 수입니다.
                self.currentPageGroup = Math.ceil(self.index / self.pageGroupSize); // 마지막 페이지가 속한 그룹으로 이동
                self.fnList();
            },
            // 현재 페이지 그룹에 표시할 페이지 번호 배열 계산
            getPageNumbers: function() {
                let self = this;
                let start = (self.currentPageGroup - 1) * self.pageGroupSize + 1;
                let end = Math.min(start + self.pageGroupSize - 1, self.index);
                
                let pages = [];
                for(let i = start; i <= end; i++) {
                    pages.push(i);
                }
                return pages;
            },
            // 이전 페이지 그룹이 있는지 확인하는 함수
            checkHasPrevGroup: function() {
                return this.currentPageGroup > 1;
            },
            // 다음 페이지 그룹이 있는지 확인하는 함수
            checkHasNextGroup: function() {
                return this.currentPageGroup < Math.ceil(this.index / this.pageGroupSize);
            }
        }, // methods
        // computed: {
        //     // 계산된 속성으로 현재 표시할 페이지 번호들 반환
        //     pageNumbers: function() {
        //         return this.getPageNumbers();
        //     },
        //     // 이전 페이지 그룹이 있는지 확인
        //     hasPrevGroup: function() {
        //         return this.currentPageGroup > 1;
        //     },
        //     // 다음 페이지 그룹이 있는지 확인
        //     hasNextGroup: function() {
        //         return this.currentPageGroup < Math.ceil(this.index / this.pageGroupSize);
        //     }
        // },
        mounted() {
            // 처음 시작할 때 실행되는 부분
            let self = this;
            self.fnList();
            self.fnSiList();
        }
    });

    app.mount('#app');
</script>