import 'package:flutter/material.dart';
import '../domain/entities/practice_tool.dart';

// --- Models ---
class Event {
  final String id;
  final String title;
  final String subtitle;
  final String status;
  final String temple;
  final String time;
  final String typeDisplay;
  final String description;
  final String formType;
  final IconData icon;

  const Event({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.status,
    required this.temple,
    required this.time,
    required this.typeDisplay,
    required this.description,
    required this.formType,
    required this.icon,
  });
}

class Category {
  final String id;
  final String label;
  const Category({required this.id, required this.label});
}

// --- Data ---
final List<PracticeTool> allPracticeTools = [
  const PracticeTool(
    id: 'beads',
    title: '虚拟念珠',
    desc: '念珠流转，心随境迁。',
    icon: Icons.circle_outlined,
  ),
  const PracticeTool(
    id: 'bell',
    title: '静心钟',
    desc: '闻钟声，烦恼轻，智慧长。',
    icon: Icons.notifications_none,
  ),
  const PracticeTool(
    id: 'fish',
    title: '线上木鱼',
    desc: '叩击木鱼，清净心神。',
    icon: Icons.spa,
  ),
  const PracticeTool(
    id: 'incense',
    title: '云端敬香',
    desc: '心香一瓣，供养十方。',
    icon: Icons.local_fire_department_outlined,
  ),
  const PracticeTool(
    id: 'copy',
    title: '在线抄经',
    desc: '沐手焚香，静心誊写。',
    icon: Icons.edit_note,
  ),
  const PracticeTool(
    id: 'breath',
    title: '观呼吸',
    desc: '一呼一吸，安住当下。',
    icon: Icons.self_improvement,
  ),
];

final List<Category> eventCategories = [
  Category(id: 'all', label: '全部'),
  Category(id: 'ceremony', label: '法会'),
  Category(id: 'lamp', label: '供灯'),
  Category(id: 'copying', label: '抄写'),
];

final List<Event> mockEvents = [
  Event(
    id: 'spring-chanting',
    title: '春季诵经法会',
    subtitle: '祈福 · 净化 · 智慧',
    status: '法会报名中',
    temple: '杭州灵隐寺 · 大雄宝殿',
    time: '每日晨课 · 05:30',
    typeDisplay: '线上直播 / 线下共修',
    description:
        '阳春布德泽，万物生光辉。春季诵经法会旨在迎春祈福，共修智慧。通过诵读经典，净化心灵，回向十方，寓意着新的开始与希望。灵隐寺诚邀十方善信，共赴法会，同沾法喜。',
    formType: 'ceremony',
    icon: Icons.menu_book_outlined,
  ),
  Event(
    id: 'daily-lamp',
    title: '日常供灯',
    subtitle: '光明 · 智慧 · 破暗',
    status: '每日可供',
    temple: '普陀山法雨寺',
    time: '每日',
    typeDisplay: '寺庙现场 / 线上供灯',
    description:
        '在佛教文化中，供灯象征着点亮心灯，开启智慧，破除无明。它是一种表达敬意与祈福的方式，寓意着光明与希望。一盏心灯，照亮前程，愿以此功德，庄严佛净土。',
    formType: 'lamp',
    icon: Icons.local_fire_department_outlined,
  ),
  Event(
    id: 'scripture-copying',
    title: '经文抄写',
    subtitle: '静心 · 专注 · 功德',
    status: '常年招募',
    temple: '苏州寒山寺 · 藏经楼',
    time: '每日 09:00 - 16:00',
    typeDisplay: '到场抄写 / 邮寄经书',
    description:
        '抄经是一项修行，旨在通过一笔一划的书写，收摄身心，长养定力。无论是亲临寺院在墨香中体悟禅意，还是恭请经书于家中静心誊写，皆是殊胜功德。愿以此净心，回向大千世界。',
    formType: 'copying',
    icon: Icons.edit_outlined,
  ),
  Event(
    id: 'meditation-retreat',
    title: '周末禅修营',
    subtitle: '止语 · 静坐 · 观心',
    status: '报名即将截止',
    temple: '终南山 · 茅蓬区',
    time: '4月15日 - 4月17日',
    typeDisplay: '线下封闭式',
    description: '远离尘嚣，回归自性。三天两夜的止语禅修，包含坐香、行香、开示与小参。适合渴望片刻宁静，探索内心世界的都市人。',
    formType: 'ceremony',
    icon: Icons.nature_people_outlined,
  ),
  Event(
    id: 'medicine-buddha-lamp',
    title: '药师佛延生灯',
    subtitle: '消灾 · 延寿 · 安康',
    status: '每月初一/十五',
    temple: '南京鸡鸣寺 · 药师塔',
    time: '每月初一/十五',
    typeDisplay: '寺庙现场 / 线上供灯',
    description: '药师琉璃光如来，誓愿宏深，普济群生。供奉药师佛延生灯，祈愿身心安康，疾病消除，家宅永安，福寿绵长。',
    formType: 'lamp',
    icon: Icons.local_fire_department,
  ),
  Event(
    id: 'guanyin-birthday',
    title: '观音圣诞法会',
    subtitle: '慈悲 · 救苦 · 广大',
    status: '农历二月十九',
    temple: '普陀山 · 普济禅寺',
    time: '08:00 - 11:30',
    typeDisplay: '现场法会',
    description: '恭迎观世音菩萨圣诞良辰。普济禅寺将举行盛大的祝圣普佛法会。愿以此功德，祈愿世界和平，国泰民安，众生离苦得乐。',
    formType: 'ceremony',
    icon: Icons.notifications_active_outlined,
  ),
  Event(
    id: 'heart-sutra-copy',
    title: '心经描红',
    subtitle: '般若 · 空性 · 自在',
    status: '随到随学',
    temple: '杭州净慈寺 · 美术馆',
    time: '每日 10:00 - 16:00',
    typeDisplay: '到场体验',
    description: '《心经》虽短，含义深远。通过描红临摹历代书法名家的心经墨迹，体会“照见五蕴皆空”的般若智慧，获得内心的自在与宁静。',
    formType: 'copying',
    icon: Icons.brush_outlined,
  ),
  Event(
    id: 'tea-ceremony',
    title: '禅茶一味雅集',
    subtitle: '品茗 · 闻香 · 悟道',
    status: '周日开放',
    temple: '杭州灵隐寺 · 韬光寺',
    time: '每周日 14:00',
    typeDisplay: '线下雅集',
    description: '茶道即禅道。在茶香缭绕中，放下执着，体会当下。本次雅集邀请资深茶人主理，共品古树普洱，分享禅修心得。',
    formType: 'ceremony',
    icon: Icons.emoji_food_beverage_outlined,
  ),
];
