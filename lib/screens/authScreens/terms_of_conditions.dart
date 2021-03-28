import 'package:flutter/material.dart';
import 'package:lifestylediet/utils/common_utils.dart';

class TermsOfConditions extends StatefulWidget {
  @override
  _TermsOfConditionsState createState() => _TermsOfConditionsState();
}

class _TermsOfConditionsState extends State<TermsOfConditions> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbar(),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: appTheme(),
        child: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (OverscrollIndicatorNotification overscroll) {
            overscroll.disallowGlow();
          },
          child: ListView(
            shrinkWrap: true,
            children: [
              _termsParagraphs(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _termsParagraphs() {
    return Column(
      children: [
        Text('Last updated March 08, 2021',
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[100],
            )),
        _termsParagraph(
          'AGREEMENT TO TERMS',
          'These Terms of Use constitute a legally binding agreement made between you, whether personally or on behalf of an entity (“you”) and LifestyleDiet ("Company", “we”, “us”, or “our”), concerning your access to and use of the lifestylediet website as well as any other media form, media channel, mobile website or mobile application related, linked, or otherwise connected thereto (collectively, the “Site”). You agree that by accessing the Site, you have read, understood, and agreed to be bound by all of these Terms of Use. IF YOU DO NOT AGREE WITH ALL OF THESE TERMS OF USE, THEN YOU ARE EXPRESSLY PROHIBITED FROM USING THE SITE AND YOU MUST DISCONTINUE USE IMMEDIATELY.'
              '\n\n Supplemental terms and conditions or documents that may be posted on the Site from time to time are hereby expressly incorporated herein by reference. We reserve the right, in our sole discretion, to make changes or modifications to these Terms of Use at any time and for any reason. We will alert you about any changes by updating the “Last updated” date of these Terms of Use, and you waive any right to receive specific notice of each such change. It is your responsibility to periodically review these Terms of Use to stay informed of updates. You will be subject to, and will be deemed to have been made aware of and to have accepted, the changes in any revised Terms of Use by your continued use of the Site after the date such revised Terms of Use are posted.'
              '\n\n The information provided on the Site is not intended for distribution to or use by any person or entity in any jurisdiction or country where such distribution or use would be contrary to law or regulation or which would subject us to any registration requirement within such jurisdiction or country. Accordingly, those persons who choose to access the Site from other locations do so on their own initiative and are solely responsible for compliance with local laws, if and to the extent local laws are applicable.'
              '\n\n The Site is not tailored to comply with industry-specific regulations (Health Insurance Portability and Accountability Act (HIPAA), Federal Information Security Management Act (FISMA), etc.), so if your interactions would be subjected to such laws, you may not use this Site. You may not use the Site in a way that would violate the Gramm-Leach-Bliley Act (GLBA).'
              '\n\n The Site is intended for users who are at least 13 years of age. All users who are minors in the jurisdiction in which they reside (generally under the age of 18) must have the permission of, and be directly supervised by, their parent or guardian to use the Site. If you are a minor, you must have your parent or guardian read and agree to these Terms of Use prior to you using the Site.',
        ),
        _termsParagraph(
          'INTELLECTUAL PROPERTY RIGHTS',
          'By using the Site, you represent and warrant that:  (1) you have the legal capacity and you agree to comply with these Terms of Use; (2) you are not under the age of 13; (3) you are not a minor in the jurisdiction in which you reside, or if a minor, you have received parental permission to use the Site; (4) you will not access the Site through automated or non-human means, whether through a bot, script, or otherwise; (5) you will not use the Site for any illegal or unauthorized purpose; and (6) your use of the Site will not violate any applicable law or regulation.'
              '\n\n If you provide any information that is untrue, inaccurate, not current, or incomplete, we have the right to suspend or terminate your account and refuse any and all current or future use of the Site (or any portion thereof).',
        ),
        _termsParagraph(
          'USER REPRESENTATIONS',
          'Unless otherwise indicated, the Site is our proprietary property and all source code, databases, functionality, software, website designs, audio, video, text, photographs, and graphics on the Site (collectively, the “Content”) and the trademarks, service marks, and logos contained therein (the “Marks”) are owned or controlled by us or licensed to us, and are protected by copyright and trademark laws and various other intellectual property rights and unfair competition laws of the United States, international copyright laws, and international conventions. The Content and the Marks are provided on the Site “AS IS” for your information and personal use only. Except as expressly provided in these Terms of Use, no part of the Site and no Content or Marks may be copied, reproduced, aggregated, republished, uploaded, posted, publicly displayed, encoded, translated, transmitted, distributed, sold, licensed, or otherwise exploited for any commercial purpose whatsoever, without our express prior written permission.'
              '\n\n Provided that you are eligible to use the Site, you are granted a limited license to access and use the Site and to download or print a copy of any portion of the Content to which you have properly gained access solely for your personal, non-commercial use. We reserve all rights not expressly granted to you in and to the Site, the Content and the Marks.',
        ),
        _termsParagraph(
          'PROHIBITED ACTIVITIES',
          'You may not access or use the Site for any purpose other than that for which we make the Site available. The Site may not be used in connection with any commercial endeavors except those that are specifically endorsed or approved by us.'
              '\n\n As a user of the Site, you agree not to:'
              '\n 1. Systematically retrieve data or other content from the Site to create or compile, directly or indirectly, a collection, compilation, database, or directory without written permission from us.'
              '\n 2. Decipher, decompile, disassemble, or reverse engineer any of the software comprising or in any way making up a part of the Site.'
              '\n 3. Use the Site as part of any effort to compete with us or otherwise use the Site and/or the Content for any revenue-generating endeavor or commercial enterprise.',
        ),
        _termsParagraph(
          'MOBILE APPLICATION LICENSE',
          'Use License'
              '\n\n If you access the Site via a mobile application, then we grant you a revocable, non-exclusive, non-transferable, limited right to install and use the mobile application on wireless electronic devices owned or controlled by you, and to access and use the mobile application on such devices strictly in accordance with the terms and conditions of this mobile application license contained in these Terms of Use. You shall not: (1) decompile, reverse engineer, disassemble, attempt to derive the source code of, or decrypt the application; (2) make any modification, adaptation, improvement, enhancement, translation, or derivative work from the application; (3) violate any applicable laws, rules, or regulations in connection with your access or use of the application; (4) remove, alter, or obscure any proprietary notice (including any notice of copyright or trademark) posted by us or the licensors of the application; (5) use the application for any revenue generating endeavor, commercial enterprise, or other purpose for which it is not designed or intended; (6) make the application available over a network or other environment permitting access or use by multiple devices or users at the same time; (7) use the application for creating a product, service, or software that is, directly or indirectly, competitive with or in any way a substitute for the application; (8) use the application to send automated queries to any website or to send any unsolicited commercial e-mail; or (9) use any proprietary information or any of our interfaces or our other intellectual property in the design, development, manufacture, licensing, or distribution of any applications, accessories, or devices for use with the application.'
              '\n\n Apple and Android Devices'
              '\n\n The following terms apply when you use a mobile application obtained from either the Apple Store or Google Play (each an “App Distributor”) to access the Site: (1) the license granted to you for our mobile application is limited to a non-transferable license to use the application on a device that utilizes the Apple iOS or Android operating systems, as applicable, and in accordance with the usage rules set forth in the applicable App Distributor’s terms of service; (2) we are responsible for providing any maintenance and support services with respect to the mobile application as specified in the terms and conditions of this mobile application license contained in these Terms of Use or as otherwise required under applicable law, and you acknowledge that each App Distributor has no obligation whatsoever to furnish any maintenance and support services with respect to the mobile application; (3) in the event of any failure of the mobile application to conform to any applicable warranty, you may notify the applicable App Distributor, and the App Distributor, in accordance with its terms and policies, may refund the purchase price, if any, paid for the mobile application, and to the maximum extent permitted by applicable law, the App Distributor will have no other warranty obligation whatsoever with respect to the mobile application; (4) you represent and warrant that (i) you are not located in a country that is subject to a U.S. government embargo, or that has been designated by the U.S. government as a “terrorist supporting” country and (ii) you are not listed on any U.S. government list of prohibited or restricted parties; (5) you must comply with applicable third-party terms of agreement when using the mobile application, e.g., if you have a VoIP application, then you must not be in violation of their wireless data service agreement when using the mobile application; and (6) you acknowledge and agree that the App Distributors are third-party beneficiaries of the terms and conditions in this mobile application license contained in these Terms of Use, and that each App Distributor will have the right (and will be deemed to have accepted the right) to enforce the terms and conditions in this mobile application license contained in these Terms of Use against you as a third-party beneficiary thereof.',
        ),
        SizedBox(height: 20),
      ],
    );
  }

  Widget _termsParagraph(String title, String paragraph) {
    return Column(
      children: [
        SizedBox(height: 20),
        Text(title,
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
            )),
        Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8, top: 8),
          child: Text(
            paragraph,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[100],
            ),
          ),
        ),
      ],
    );
  }

  Widget _appbar() {
    return AppBar(
      elevation: 0,
      backgroundColor: backgroundColor,
      title: Text('Terms of Conditions', style: mealTextStyle),
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: defaultColor,
        ),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }
}
