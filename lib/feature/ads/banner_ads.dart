import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:easy_localization/easy_localization.dart';

class banner_ads extends StatefulWidget {
  banner_ads({super.key});

  @override
  State<banner_ads> createState() => _banner_adsState();
}

class _banner_adsState extends State<banner_ads> {
  RewardedAd? _rewardedAd;
  bool _isRewardedLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadRewardedAd();
  }

  void _loadRewardedAd() {
    RewardedAd.load(
      adUnitId: "ca-app-pub-3940256099942544/5224354917", //  Test Rewarded
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;

          _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              setState(() {
                _rewardedAd = null;
                _isRewardedLoaded = false;
              });
              _loadRewardedAd();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              setState(() {
                _rewardedAd = null;
                _isRewardedLoaded = false;
              });
              _loadRewardedAd();
            },
          );

          setState(() {
            _isRewardedLoaded = true;
          });
        },
        onAdFailedToLoad: (error) {
          setState(() {
            _isRewardedLoaded = false;
          });
        },
      ),
    );
  }

  void _showRewardedAd() {
    if (_rewardedAd == null) return;

    _rewardedAd!.show(
      onUserEarnedReward: (ad, reward) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Reward earned ".tr())),
        );

      },
    );
  }

  @override
  void dispose() {
    _rewardedAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //  هون “تصميم الصفحة”
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text("Rewards".tr()),
        centerTitle: true,
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              final lang = context.locale.languageCode;
              if (lang == "en") {
                context.setLocale( Locale("ar"));
              } else {
                context.setLocale( Locale("en"));
              }
            },
            icon:  Icon(Icons.language),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding:  EdgeInsets.all(16),
          child: Card(
            elevation: 3,
            child: Padding(
              padding:  EdgeInsets.all(18),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 34,
                    backgroundColor: Colors.green.withOpacity(0.12),
                    child:  Icon(Icons.card_giftcard, color: Colors.green, size: 34),
                  ),
                  SizedBox(height: 12),
                  Text(
                    "Get a reward".tr(),
                    style:  TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 6),
                  Text(
                    "Watch a short ad to unlock a feature.".tr(),
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                  SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _isRewardedLoaded ? _showRewardedAd : null,
                      icon:  Icon(Icons.play_arrow),
                      label: Text(_isRewardedLoaded ? "Watch now".tr() : "Loading...".tr()),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding:  EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

