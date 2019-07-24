import 'package:flutter/material.dart';

class MobcentForumFaces {
  static String findAsset(String label) {
    String id;
    for (var kv in faceLabelMap.entries) {
      if (kv.value == label) {
        id = kv.key;
        break;
      }
    }

    if (id == null) {
      return null;
    }

    var asset = faceAssetMap[id] ?? faceQQAssetMap[id] ?? faceMAssetMap[id];
    return asset == null ? null : "assets/faces/${asset}.png";
  }

  static Image loadAssetImage(String label, {double size = 16}) {
    String id;
    for (var kv in faceLabelMap.entries) {
      if (kv.value == label) {
        id = kv.key;
        break;
      }
    }

    if (id == null) {
      return Image(width: size ?? 16, height: size ?? 16);
    }

    var asset = faceAssetMap[id] ?? faceQQAssetMap[id] ?? faceMAssetMap[id];
    return asset == null
        ? Image(width: size ?? 16, height: size ?? 16)
        : Image.asset(
            "assets/faces/${asset}.png",
            width: size ?? 16,
            height: size ?? 16,
          );
  }

  static const Map<String, String> faceLabelMap = {
    "mc_forum_face_haha": "[哈哈]",
    "mc_forum_face_tear": "[泪]",
    "mc_forum_face_crazy": "[抓狂]",
    "mc_forum_face_xixi": "[嘻嘻]",
    "mc_forum_face_titter": "[偷笑]",
    "mc_forum_face_clap": "[鼓掌]",
    "mc_forum_face_fury": "[怒]",
    "mc_forum_face_heart": "[心]",
    "mc_forum_face_heart_broken": "[心碎了]",
    "mc_forum_face_sick": "[生病]",
    "mc_forum_face_love": "[爱你]",
    "mc_forum_face_shy": "[害羞]",
    "mc_forum_face_poor": "[可怜]",
    "mc_forum_face_greedy": "[馋嘴]",
    "mc_forum_face_faint": "[晕]",
    "mc_forum_face_hana": "[花心]",
    "mc_forum_face_too_happy": "[太开心]",
    "mc_forum_face_kiss": "[亲亲]",
    "mc_forum_face_disdain": "[鄙视]",
    "mc_forum_face_hehe": "[呵呵]",
    "mc_forum_face_booger": "[挖鼻屎]",
    "mc_forum_face_decline": "[衰]",
    "mc_forum_face_rabbit": "[兔子]",
    "mc_forum_face_good": "[good]",
    "mc_forum_face_come": "[来]",
    "mc_forum_face_force": "[威武]",
    "mc_forum_face_circusee": "[围观]",
    "mc_forum_face_sprout": "[萌]",
    "mc_forum_face_flowers": "[送花]",
    "mc_forum_face_confused": "[囧]",
    "mc_forum_face_cruel": "[酷]",
    "mc_forum_face_solid_food": "[糗大了]",
    "mc_forum_face_mouth": "[撇嘴]",
    "mc_forum_face_asleep": "[发呆]",
    "mc_forum_face_sweat": "[汗]",
    "mc_forum_face_sleep": "[睡]",
    "mc_forum_face_surprise": "[吃惊]",
    "mc_forum_face_white_eye": "[白眼]",
    "mc_forum_face_white_query": "[疑问]",
    "mc_forum_face_cattiness": "[阴险]",
    "mc_forum_face_left_humph": "[左哼哼]",
    "mc_forum_face_right_humph": "[右哼哼]",
    "mc_forum_face_knock": "[敲打]",
    "mc_forum_face_chagrin": "[委屈]",
    "mc_forum_face_hush": "[嘘]",
    "mc_forum_face_spit": "[吐]",
    "mc_forum_face_grimace": "[做鬼脸]",
    "mc_forum_face_bye": "[ByeBye]",
    "mc_forum_face_cry": "[快哭了]",
    "mc_forum_face_arrogance": "[傲慢]",
    "mc_forum_face_moon": "[月亮]",
    "mc_forum_face_sun": "[太阳]",
    "mc_forum_face_ye": "[耶]",
    "mc_forum_face_handshake": "[握手]",
    "mc_forum_face_ok": "[ok]",
    "mc_forum_face_coffee": "[咖啡]",
    "mc_forum_face_meal": "[饭]",
    "mc_forum_face_gift": "[礼物]",
    "mc_forum_face_pig_head": "[猪头]",
    "mc_forum_face_hug": "[抱抱]",
    "mc_forum_face_praise": "[赞]",
    "mc_forum_face_hold": "[Hold]",
    "mc_forum_face_sleipnir": "[神马]",
    "mc_forum_face_cheating": "[坑爹]",
    "mc_forum_face_have": "[有木有]",
    "mc_forum_face_thanks": "[谢谢]",
    "mc_forum_face_demon": "[魔鬼]",
    "mc_forum_face_saucer_man": "[外星人]",
    "mc_forum_face_blue_heart": "[蓝心]",
    "mc_forum_face_purple_heart": "[紫心]",
    "mc_forum_face_yellow_heart": "[黄心]",
    "mc_forum_face_green_heart": "[绿心]",
    "mc_forum_face_music": "[音乐]",
    "mc_forum_face_flicker": "[闪烁]",
    "mc_forum_face_star": "[星星]",
    "mc_forum_face_drip": "[雨滴]",
    "mc_forum_face_flame": "[火焰]",
    "mc_forum_face_shit": "[便便]",
    "mc_forum_face_foot": "[踩一脚]",
    "mc_forum_face_rain": "[下雨]",
    "mc_forum_face_cloudy": "[多云]",
    "mc_forum_face_lightning": "[闪电]",
    "mc_forum_face_snowflake": "[雪花]",
    "mc_forum_face_cyclone": "[旋风]",
    "mc_forum_face_bag": "[包]",
    "mc_forum_face_house": "[房子]",
    "mc_forum_face_fireworks": "[烟花]",
  };
  static const Map<String, String> faceAssetMap = {
    "mc_forum_face_tear": "mc_forum_face198",
    "mc_forum_face_haha": "mc_forum_face234",
    "mc_forum_face_crazy": "mc_forum_face239",
    "mc_forum_face_xixi": "mc_forum_face233",
    "mc_forum_face_titter": "mc_forum_face247",
    "mc_forum_face_clap": "mc_forum_face255",
    "mc_forum_face_fury": "mc_forum_face242",
    "mc_forum_face_heart": "mc_forum_face279",
    "mc_forum_face_heart_broken": "mc_forum_face280",
    "mc_forum_face_sick": "mc_forum_face258",
    "mc_forum_face_love": "mc_forum_face17",
    "mc_forum_face_shy": "mc_forum_face201",
    "mc_forum_face_poor": "mc_forum_face268",
    "mc_forum_face_greedy": "mc_forum_face238",
    "mc_forum_face_faint": "mc_forum_face7",
    "mc_forum_face_hana": "mc_forum_face254",
    "mc_forum_face_too_happy": "mc_forum_face261",
    "mc_forum_face_kiss": "mc_forum_face259",
    "mc_forum_face_disdain": "mc_forum_face252",
    "mc_forum_face_hehe": "mc_forum_face25",
    "mc_forum_face_booger": "mc_forum_face253",
    "mc_forum_face_decline": "mc_forum_face6",
    "mc_forum_face_rabbit": "mc_forum_rabbit_thumb",
    "mc_forum_face_good": "mc_forum_face100",
    "mc_forum_face_come": "mc_forum_face277",
    "mc_forum_face_force": "mc_forum_face219",
    "mc_forum_face_circusee": "mc_forum_face218",
    "mc_forum_face_sprout": "mc_forum_kawayi_thumb",
    "mc_forum_face_flowers": "mc_forum_face120",
    "mc_forum_face_confused": "mc_forum_face121",
  };
  static const Map<String, String> faceQQAssetMap = {
    "mc_forum_face_cruel": "mc_forum_qq_01",
    "mc_forum_face_solid_food": "mc_forum_qq_02",
    "mc_forum_face_mouth": "mc_forum_qq_03",
    "mc_forum_face_asleep": "mc_forum_qq_04",
    "mc_forum_face_sweat": "mc_forum_qq_05",
    "mc_forum_face_sleep": "mc_forum_qq_06",
    "mc_forum_face_surprise": "mc_forum_qq_11",
    "mc_forum_face_white_eye": "mc_forum_qq_12",
    "mc_forum_face_white_query": "mc_forum_qq_13",
    "mc_forum_face_cattiness": "mc_forum_qq_14",
    "mc_forum_face_left_humph": "mc_forum_qq_15",
    "mc_forum_face_right_humph": "mc_forum_qq_16",
    "mc_forum_face_knock": "mc_forum_qq_21",
    "mc_forum_face_chagrin": "mc_forum_qq_22",
    "mc_forum_face_hush": "mc_forum_qq_23",
    "mc_forum_face_spit": "mc_forum_qq_24",
    "mc_forum_face_grimace": "mc_forum_qq_25",
    "mc_forum_face_bye": "mc_forum_qq_26",
    "mc_forum_face_cry": "mc_forum_qq_31",
    "mc_forum_face_arrogance": "mc_forum_qq_32",
    "mc_forum_face_moon": "mc_forum_qq_33",
    "mc_forum_face_sun": "mc_forum_qq_34",
    "mc_forum_face_ye": "mc_forum_qq_35",
    "mc_forum_face_handshake": "mc_forum_qq_36",
    "mc_forum_face_ok": "mc_forum_qq_41",
    "mc_forum_face_coffee": "mc_forum_qq_42",
    "mc_forum_face_meal": "mc_forum_qq_43",
    "mc_forum_face_gift": "mc_forum_qq_44",
    "mc_forum_face_pig_head": "mc_forum_qq_45",
    "mc_forum_face_hug": "mc_forum_qq_46",
  };
  static const Map<String, String> faceMAssetMap = {
    "mc_forum_face_praise": "mc_forum_m_01",
    "mc_forum_face_hold": "mc_forum_m_02",
    "mc_forum_face_sleipnir": "mc_forum_m_03",
    "mc_forum_face_cheating": "mc_forum_m_04",
    "mc_forum_face_have": "mc_forum_m_05",
    "mc_forum_face_thanks": "mc_forum_m_06",
    "mc_forum_face_demon": "mc_forum_m_11",
    "mc_forum_face_saucer_man": "mc_forum_m_12",
    "mc_forum_face_blue_heart": "mc_forum_m_13",
    "mc_forum_face_purple_heart": "mc_forum_m_14",
    "mc_forum_face_yellow_heart": "mc_forum_m_15",
    "mc_forum_face_green_heart": "mc_forum_m_16",
    "mc_forum_face_music": "mc_forum_m_21",
    "mc_forum_face_flicker": "mc_forum_m_22",
    "mc_forum_face_star": "mc_forum_m_23",
    "mc_forum_face_drip": "mc_forum_m_24",
    "mc_forum_face_flame": "mc_forum_m_25",
    "mc_forum_face_shit": "mc_forum_m_26",
    "mc_forum_face_foot": "mc_forum_m_31",
    "mc_forum_face_rain": "mc_forum_m_32",
    "mc_forum_face_cloudy": "mc_forum_m_33",
    "mc_forum_face_lightning": "mc_forum_m_34",
    "mc_forum_face_snowflake": "mc_forum_m_35",
    "mc_forum_face_cyclone": "mc_forum_m_36",
    "mc_forum_face_bag": "mc_forum_m_41",
    "mc_forum_face_house": "mc_forum_m_42",
    "mc_forum_face_fireworks": "mc_forum_m_43",
  };
}
