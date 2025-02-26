import 'package:flutter/material.dart';
import 'package:pirahesh_shop/data/common/constants.dart';

import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../common/utils.dart';
import '../../data/model/banner.dart';
import 'image.dart';

class BannerSlider extends StatelessWidget {
  final PageController _controller = PageController();
  final List<BannerEntity> banners;
  BannerSlider({Key? key, required this.banners}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.7,
      child: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _controller,
              itemCount: banners.length,
              physics: defaultScrollPhysics,
              itemBuilder: (context, index) => _Slide(banner: banners[index]),
            ),
          ),
          SizedBox(height: 16),
          Center(
            child: SmoothPageIndicator(
              controller: _controller,
              count: banners.length,
              axisDirection: Axis.horizontal,
              effect: WormEffect(
                  spacing: 4.0,
                  radius: 4.0,
                  dotWidth: 20.0,
                  dotHeight: 2.0,
                  paintStyle: PaintingStyle.fill,
                  dotColor: Colors.grey.shade400,
                  activeDotColor: Theme.of(context).colorScheme.onSurface),
            ),
          ),
        ],
      ),
    );
  }
}

class _Slide extends StatelessWidget {
  final BannerEntity banner;
  const _Slide({
    Key? key,
    required this.banner,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 12),
      child: ImageLoadingService(
        imageUrl: Constants.baseImageUrl + banner.imageUrl,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
