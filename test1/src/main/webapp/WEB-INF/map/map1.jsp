<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=6c1b6e5447cc85d2d8cf6d7501711d45&libraries=services"></script>
    <style>
        
    </style>
</head>
<body>
    <div id="app">
        <!-- html 코드는 id가 app인 태그 안에서 작업 -->
        <select v-model="selectedCategory" @change="searchPlaces" style="margin-bottom: 20px; padding:5px">
            <option value="">:: 선택 ::</option>
            <option value="MT1">대형마트</option>
            <option value="CS2">편의점</option>
            <option value="PS3">어린이집, 유치원</option>
            <option value="SC4">학교</option>
            <option value="AC5">학원</option>
            <option value="PK6">주차장</option>
            <option value="OL7">주유소, 충전소</option>
            <option value="SW8">지하철역</option>
            <option value="BK9">은행</option>
            <option value="CT1">문화시설</option>
            <option value="AG2">중개업소</option>
            <option value="PO3">공공기관</option>
            <option value="AT4">관광명소</option>
            <option value="AD5">숙박</option>
            <option value="FD6">음식점</option>
            <option value="CE7">카페</option>
            <option value="HP8">병원</option>
            <option value="PM9">약국</option>
        </select>
        <div id="map" style="width:500px;height:400px;"></div>
    </div>
</body>
</html>

<script>
    const app = Vue.createApp({
        data() {
            return {
                // 변수 추가
                selectedCategory: 'BK9', // 기본값으로 은행 설정
                map: null,
                ps: null,
                infowindow: null
            };
        },
        methods: {
            // 카테고리 검색 메소드
            searchPlaces() {
                if (!this.selectedCategory) {
                    alert('카테고리를 선택해주세요');
                    return;
                }
                
                // 선택된 카테고리로 검색
                this.ps.categorySearch(this.selectedCategory, this.placesSearchCB, {
                    useMapBounds: true
                });
            },
            
            // 검색 콜백 함수
            placesSearchCB(data, status, pagination) {
                if (status === kakao.maps.services.Status.OK) {
                    // 기존 마커 제거 (마커 배열을 관리하는 코드 추가 필요)
                    this.removeAllMarkers();
                    
                    // 새로운 마커 표시
                    for (var i=0; i<data.length; i++) {
                        this.displayMarker(data[i]);    
                    }       
                }
            },
            
            // 마커 표시 함수
            displayMarker(place) {
                // 마커를 생성하고 지도에 표시
                var marker = new kakao.maps.Marker({
                    map: this.map,
                    position: new kakao.maps.LatLng(place.y, place.x) 
                });
                
                // 마커 배열에 추가 (추가 구현 필요)
                this.markers.push(marker);

                // 마커 클릭 이벤트
                kakao.maps.event.addListener(marker, 'click', () => {
                    this.infowindow.setContent('<div style="padding:5px;font-size:12px;">' + place.place_name + '</div>');
                    this.infowindow.open(this.map, marker);
                });
            },
            
            // 모든 마커 제거 함수
            removeAllMarkers() {
                for (let i = 0; i < this.markers.length; i++) {
                    this.markers[i].setMap(null);
                }
                this.markers = [];
            }
        },
        mounted() {
            // 초기화 부분
            let self = this;
            this.markers = []; // 마커 배열 초기화
            
            // 인포윈도우 생성
            this.infowindow = new kakao.maps.InfoWindow({zIndex:1});

            // 지도 생성
            var mapContainer = document.getElementById('map');
            var mapOption = {
                center: new kakao.maps.LatLng(37.566826, 126.9786567),
                level: 3
            };  
            
            this.map = new kakao.maps.Map(mapContainer, mapOption);
            
            // 장소 검색 객체 생성
            this.ps = new kakao.maps.services.Places(this.map);
            
            // Vue 인스턴스의 메소드를 콜백으로 사용하기 위한 바인딩
            this.placesSearchCB = this.placesSearchCB.bind(this);
            
            // 초기 검색 실행
            this.searchPlaces();
        }
    });

    app.mount('#app');
</script>