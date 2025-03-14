import 'package:flutter/material.dart';
class StudyImagePagination extends StatefulWidget {
  const StudyImagePagination({super.key});

  @override
  _StudyImagePaginationState createState() => _StudyImagePaginationState();
}

class _StudyImagePaginationState extends State<StudyImagePagination> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<String> studyImages = [
    'assets/images/study2.jpeg',
    'assets/images/study3.jpeg',
    'assets/images/study4.jpeg',
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250, // Set a fixed height
      child: Stack(
        alignment: Alignment.topCenter, // Aligns indicator at the top
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: studyImages.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              return Image.asset(studyImages[index], fit: BoxFit.cover);
            },
          ),
          Positioned(
            bottom: 10, // Adjusts the position of the indicator
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                studyImages.length,
                    (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  height: 8,
                  width: _currentPage == index ? 16 : 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index ? Colors.blue : Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
