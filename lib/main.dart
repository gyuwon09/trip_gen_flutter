import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_html/flutter_html.dart';

List<List<String>> places = [
  ["강원도 평창군", "모나 용평 리조트", "https://i.namu.wiki/i/3oOpb1tw8p7dNRjdCmu0_LlkJbESn0jIcInMO-uX7VfkqXZDskgFN7YFD8MuvlRVJVGj-tswmkzUdAZVBtHUVA.webp"],
  ["충청북도 단양", "이끼터널", "https://media.triple.guide/triple-cms/c_limit,f_auto,h_1024,w_1024/86b9fdd9-242b-4bea-ba31-80493d37e7ba.jpeg"],
  ["충청남도 당진", "삽교호 놀이동산", "https://tong.visitkorea.or.kr/cms/resource/92/3026192_image2_1.jpg"],
  ["경기도 용인시", "에버랜드", "https://upload.wikimedia.org/wikipedia/commons/thumb/d/d3/%EC%97%90%EB%B2%84%EB%9E%9C%EB%93%9C_%EA%B4%80%EB%9E%8C%EC%B0%A8_%EC%A0%95%EC%9B%90_2025.jpg/960px-%EC%97%90%EB%B2%84%EB%9E%9C%EB%93%9C_%EA%B4%80%EB%9E%8C%EC%B0%A8_%EC%A0%95%EC%9B%90_2025.jpg"],
];
List<List<String>> jobs = [
  ["모나 용평 리조트", "인형탈 알바", "https://1.bp.blogspot.com/-GJxs0OHKNro/XRq3yEbc5tI/AAAAAAAACeE/tPS7Lj2gmUMeOLSc6wYJ9-CM2N8tXKjVQCLcBGAs/s1600/9.gif"],
  ["이끼터널", "주차 안내원", "https://newsimg.sedaily.com/2016/11/03/1L3TT6196V_1.jpg"],
  ["삽교호 놀이동산", "바텐더", "https://www.drinkmagazine.asia/wp-content/uploads/2001/10/web-ounce.jpg"],
  ["에버랜드", "탭댄서", "https://dimg.donga.com/wps/NEWS/IMAGE/2021/07/12/107921227.1.jpg"]
];

const String domain = "http://124.50.174.4:9999";

void is_server_available() async {
  print("domain : $domain");

  final url = Uri.parse(domain);
  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('응답 데이터: $data');
      runApp(MyApp());
    } else {
      print('요청 실패: ${response.statusCode}');
      runApp(NoApp());
    }
  } catch (e) {
    print('오류 발생: $e');
    runApp(NoApp());
  }
}

void main() {
  is_server_available();
}

class NoApp extends StatelessWidget {
  const NoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '점검 중',
      debugShowCheckedModeBanner: false,
      home: const MaintenancePage(),
    );
  }
}

class MaintenancePage extends StatelessWidget {
  const MaintenancePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.build_rounded, size: 80, color: Colors.orange[800]),
              const SizedBox(height: 24),
              const Text(
                '서버 점검 중입니다',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text(
                '더 나은 서비스를 제공하기 위해\n현재 서버 점검을 진행 중입니다.\n잠시 후 다시 이용해 주세요.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 32),
              const CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}

// 앱 전체를 감싸는 MyApp
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '관광지 앱',
      theme: ThemeData(fontFamily: 'Pretendard'),
      home: MainPage(),
    );
  }
}

// 하단 네비게이션과 화면 전환을 관리하는 MainPage
class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    TouristSearchPage(),
    JobSearchPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        backgroundColor: Color(0xFF0D1B2A),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey[400],
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.search), label: '관광지 검색'),
          BottomNavigationBarItem(icon: Icon(Icons.work), label: '직업 검색'),
        ],
      ),
    );
  }
}

// 관광지 검색 화면
class TouristSearchPage extends StatelessWidget {
  final List<Map<String, String>> recommendedPlaces = List.generate(
    places.length,
        (index) => {
      "title": places[index][0],
      "subtitle": places[index][1],
      "image": places[index][2]
    },
  );

  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          Center(
            child: Column(
              children: [
                Text('관광지 검색', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
                SizedBox(height: 6),
                Text('가고싶은 관광 지역을 검색하세요', style: TextStyle(color: Colors.grey[600])),
              ],
            ),
          ),
          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 1.4),
                borderRadius: BorderRadius.circular(32),
              ),
              child: Row(
                children: [
                  Icon(Icons.search, color: Colors.black),
                  SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onSubmitted: (query) {
                        if (query.trim().isNotEmpty) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TripLoadingPage(query: query),
                            ),
                          );
                        }
                      },
                      decoration: InputDecoration(
                        hintText: '검색하려면 여기를 누르세요',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text('관광지 추천', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          ),
          SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: recommendedPlaces.length,
              itemBuilder: (context, index) {
                final place = recommendedPlaces[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Stack(
                      alignment: Alignment.bottomLeft,
                      children: [
                        Image.network(
                          place['image']!,
                          width: double.infinity,
                          height: 160,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(color: Colors.grey, height: 160, child: Center(child: Text('이미지 로드 실패'))),
                        ),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.black.withOpacity(0.7), Colors.transparent],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(place['title']!, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                              Text(place['subtitle']!, style: TextStyle(color: Colors.white70, fontSize: 14)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// 로딩 페이지
class TripLoadingPage extends StatefulWidget {
  final String query;

  const TripLoadingPage({super.key, required this.query});

  @override
  State<TripLoadingPage> createState() => _TripLoadingPageState();
}

class _TripLoadingPageState extends State<TripLoadingPage> {
  @override
  void initState() {
    super.initState();
    _searchTouristPlace();
  }

  void _searchTouristPlace() async {
    final url = Uri.parse("$domain/trip_search/${Uri.encodeComponent(widget.query)}");
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final htmlBody = response.body;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SearchResultPage(htmlContent: htmlBody),
          ),
        );
      } else {
        _showError('검색에 실패했습니다.');
      }
    } catch (e) {
      _showError('네트워크 오류가 발생했습니다.');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text('관광지를 검색 중입니다...', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}

// 로딩 페이지
class JobLoadingPage extends StatefulWidget {
  final String query;

  const JobLoadingPage({super.key, required this.query});

  @override
  State<JobLoadingPage> createState() => _JobLoadingPageState();
}

class _JobLoadingPageState extends State<JobLoadingPage> {
  @override
  void initState() {
    super.initState();
    _searchJobPlace();
  }

  void _searchJobPlace() async {
    final url = Uri.parse("$domain/search_job/${Uri.encodeComponent(widget.query)}");
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final htmlBody = response.body;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SearchResultPage(htmlContent: htmlBody),
          ),
        );
      } else {
        _showError('검색에 실패했습니다.');
      }
    } catch (e) {
      _showError('네트워크 오류가 발생했습니다.');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text('일자리를 검색 중입니다...', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}


// 결과 페이지
class SearchResultPage extends StatelessWidget {
  final String htmlContent;

  const SearchResultPage({super.key, required this.htmlContent});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('검색 결과')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Html(data: htmlContent),
      ),
    );
  }
}


// 직업 검색 화면
class JobSearchPage extends StatelessWidget {
  final List<Map<String, String>> recommendedPlaces = List.generate(
    jobs.length,
        (index) => {
      "title": jobs[index][0],
      "subtitle": jobs[index][1],
      "image": jobs[index][2]
    },
  );

  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          Center(
            child: Column(
              children: [
                Text('일자리 검색', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
                SizedBox(height: 6),
                Text('원하는 관광지의 일자리를 검색하세요', style: TextStyle(color: Colors.grey[600])),
              ],
            ),
          ),
          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 1.4),
                borderRadius: BorderRadius.circular(32),
              ),
              child: Row(
                children: [
                  Icon(Icons.search, color: Colors.black),
                  SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onSubmitted: (query) {
                        if (query.trim().isNotEmpty) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => JobLoadingPage(query: query),
                            ),
                          );
                        }
                      },
                      decoration: InputDecoration(
                        hintText: '검색하려면 여기를 누르세요',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text('일자리 추천', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          ),
          SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: recommendedPlaces.length,
              itemBuilder: (context, index) {
                final place = recommendedPlaces[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Stack(
                      alignment: Alignment.bottomLeft,
                      children: [
                        Image.network(
                          place['image']!,
                          width: double.infinity,
                          height: 160,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(color: Colors.grey, height: 160, child: Center(child: Text('이미지 로드 실패'))),
                        ),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.black.withOpacity(0.7), Colors.transparent],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(place['title']!, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                              Text(place['subtitle']!, style: TextStyle(color: Colors.white70, fontSize: 14)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

