import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wise_app/features/contacts/contacts_controller.dart';
import 'package:wise_app/features/contacts/contacts_model.dart';

class ContactsScreen extends ConsumerStatefulWidget {
  const ContactsScreen({super.key});

  @override
  ConsumerState<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends ConsumerState<ContactsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isSearching = false;
  String? _selectedOrganization;
  List<String> _recentSearches = ['김철수', '백엔드팀', '마케팅'];

  @override
  void initState() {
    super.initState();
  }

  String _getSelectedOrgName(List<Organization> organizations) {
    if (_selectedOrganization == null) return '전체';
    final org = organizations.firstWhere(
      (o) => o.id == _selectedOrganization,
      orElse: () => Organization(id: '', name: '전체'),
    );
    return org.name;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // 초성 검색 지원
  bool _matchesSearch(Contact contact, String query) {
    if (query.isEmpty) return true;

    final lowerQuery = query.toLowerCase();
    final name = contact.username ?? '';
    final dept = contact.department ?? '';
    final position = contact.position ?? '';

    // 일반 검색
    if (name.toLowerCase().contains(lowerQuery) ||
        dept.toLowerCase().contains(lowerQuery) ||
        position.toLowerCase().contains(lowerQuery)) {
      return true;
    }

    // 초성 검색
    if (_isKoreanInitials(query)) {
      final nameInitials = _getKoreanInitials(name);
      return nameInitials.contains(query);
    }

    return false;
  }

  bool _isKoreanInitials(String text) {
    const initials = 'ㄱㄲㄴㄷㄸㄹㅁㅂㅃㅅㅆㅇㅈㅉㅊㅋㅌㅍㅎ';
    return text.split('').every((char) => initials.contains(char));
  }

  String _getKoreanInitials(String text) {
    const initials = [
      'ㄱ',
      'ㄲ',
      'ㄴ',
      'ㄷ',
      'ㄸ',
      'ㄹ',
      'ㅁ',
      'ㅂ',
      'ㅃ',
      'ㅅ',
      'ㅆ',
      'ㅇ',
      'ㅈ',
      'ㅉ',
      'ㅊ',
      'ㅋ',
      'ㅌ',
      'ㅍ',
      'ㅎ',
    ];
    final buffer = StringBuffer();

    for (final char in text.runes) {
      if (char >= 0xAC00 && char <= 0xD7A3) {
        final index = ((char - 0xAC00) / 588).floor();
        buffer.write(initials[index]);
      }
    }

    return buffer.toString();
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
        _searchQuery = '';
      }
    });
  }

  void _addToRecentSearches(String query) {
    if (query.isNotEmpty && !_recentSearches.contains(query)) {
      setState(() {
        _recentSearches.insert(0, query);
        if (_recentSearches.length > 5) {
          _recentSearches = _recentSearches.sublist(0, 5);
        }
      });
    }
  }

  void _showOrganizationPicker(
    List<Organization> organizations,
    List<Contact> contacts,
  ) {
    // 조직별 인원수 계산 (하위 조직 포함)
    int getContactCount(String? orgId) {
      if (orgId == null) return contacts.length;

      // 해당 조직 + 하위 조직의 모든 인원수
      final childOrgIds = _getDescendantOrgIds(orgId, organizations);
      return contacts
          .where(
            (c) =>
                c.organizationId == orgId ||
                childOrgIds.contains(c.organizationId),
          )
          .length;
    }

    // 최상위 조직만 필터 (level == 1: 본부)
    final topLevelOrgs = organizations.where((o) => o.level == 1).toList();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.3,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) => Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    Text(
                      '조직 선택',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        setState(() => _selectedOrganization = null);
                        Navigator.pop(context);
                      },
                      child: const Text('전체 보기'),
                    ),
                  ],
                ),
              ),
              const Divider(),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  children: [
                    // 전체 항목
                    _buildOrgTile(
                      context: context,
                      orgId: null,
                      name: '전체',
                      count: contacts.length,
                      icon: Icons.groups,
                      isSelected: _selectedOrganization == null,
                      onTap: () {
                        setState(() => _selectedOrganization = null);
                        Navigator.pop(context);
                      },
                    ),
                    const Divider(height: 1),
                    // 본부별 ExpansionTile
                    ...topLevelOrgs.map((division) {
                      final childOrgs = organizations
                          .where((o) => o.parentId == division.id)
                          .toList();
                      final isSelected = division.id == _selectedOrganization;
                      final hasSelectedChild = childOrgs.any(
                        (c) => c.id == _selectedOrganization,
                      );

                      if (childOrgs.isEmpty) {
                        // 하위 조직이 없으면 일반 ListTile
                        return _buildOrgTile(
                          context: context,
                          orgId: division.id,
                          name: division.name,
                          count: getContactCount(division.id),
                          icon: Icons.corporate_fare,
                          isSelected: isSelected,
                          onTap: () {
                            setState(() => _selectedOrganization = division.id);
                            Navigator.pop(context);
                          },
                        );
                      }

                      // 하위 조직이 있으면 ExpansionTile
                      return _ExpandableOrgTile(
                        division: division,
                        childOrgs: childOrgs,
                        isSelected: isSelected,
                        initiallyExpanded: hasSelectedChild || isSelected,
                        contactCount: getContactCount(division.id),
                        selectedOrganization: _selectedOrganization,
                        onSelectDivision: () {
                          setState(() => _selectedOrganization = division.id);
                          Navigator.pop(context);
                        },
                        onSelectTeam: (teamId) {
                          setState(() => _selectedOrganization = teamId);
                          Navigator.pop(context);
                        },
                        getContactCount: getContactCount,
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 하위 조직 ID 목록 가져오기
  Set<String> _getDescendantOrgIds(String parentId, List<Organization> orgs) {
    final descendants = <String>{};
    final directChildren = orgs.where((o) => o.parentId == parentId);
    for (final child in directChildren) {
      descendants.add(child.id);
      descendants.addAll(_getDescendantOrgIds(child.id, orgs));
    }
    return descendants;
  }

  // 조직 타일 빌더
  Widget _buildOrgTile({
    required BuildContext context,
    required String? orgId,
    required String name,
    required int count,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
    double indent = 0,
  }) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: isSelected
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.surfaceContainerHighest,
        child: Icon(icon, color: isSelected ? Colors.white : null, size: 20),
      ),
      title: Text(
        '$name ($count)',
        style: TextStyle(
          fontWeight: indent > 0 ? FontWeight.normal : FontWeight.bold,
          color: isSelected ? Theme.of(context).colorScheme.primary : null,
        ),
      ),
      trailing: isSelected
          ? Icon(
              Icons.check_circle,
              color: Theme.of(context).colorScheme.primary,
            )
          : null,
      contentPadding: EdgeInsets.only(left: 16 + indent, right: 16),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    final contactsAsync = ref.watch(contactsControllerProvider);
    final organizationsAsync = ref.watch(organizationsControllerProvider);
    final favoritesAsync = ref.watch(favoriteControllerProvider);

    final contacts = contactsAsync.value ?? [];
    final organizations = organizationsAsync.value ?? [];
    final selectedOrgName = _getSelectedOrgName(organizations);
    final favoriteIds = favoritesAsync.value ?? {};

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: '이름, 부서, 초성(ㄱㅊㅅ)으로 검색...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.5),
                    fontSize: 14,
                  ),
                ),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                onChanged: (value) => setState(() => _searchQuery = value),
                onSubmitted: _addToRecentSearches,
              )
            : InkWell(
                onTap: () => _showOrganizationPicker(organizations, contacts),
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 8,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        selectedOrgName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Icon(Icons.arrow_drop_down, size: 24),
                    ],
                  ),
                ),
              ),
        leading: _isSearching
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: _toggleSearch,
              )
            : null,
        actions: [
          if (!_isSearching)
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: _toggleSearch,
            ),
          if (_isSearching && _searchQuery.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _searchController.clear();
                setState(() => _searchQuery = '');
              },
            ),
        ],
      ),
      body: contactsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('오류: $error')),
        data: (contacts) {
          // 선택된 조직 + 하위 조직 ID 목록
          final selectedOrgIds = _selectedOrganization != null
              ? {
                  _selectedOrganization!,
                  ..._getDescendantOrgIds(
                    _selectedOrganization!,
                    organizations,
                  ),
                }
              : <String>{};

          // 필터링
          var filteredContacts = contacts.where((c) {
            // 조직 필터
            if (_selectedOrganization != null &&
                !selectedOrgIds.contains(c.organizationId)) {
              return false;
            }
            return _matchesSearch(c, _searchQuery);
          }).toList();

          // 즐겨찾기 상단 정렬
          filteredContacts.sort((a, b) {
            final aFav = favoriteIds.contains(a.id);
            final bFav = favoriteIds.contains(b.id);
            if (aFav && !bFav) return -1;
            if (!aFav && bFav) return 1;
            return (a.username ?? '').compareTo(b.username ?? '');
          });

          return Column(
            children: [
              // 최근 검색 (검색 모드일 때만)
              if (_isSearching &&
                  _searchQuery.isEmpty &&
                  _recentSearches.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            '최근 검색',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: () =>
                                setState(() => _recentSearches.clear()),
                            child: const Text('전체 삭제'),
                          ),
                        ],
                      ),
                      Wrap(
                        spacing: 8,
                        children: _recentSearches
                            .map(
                              (search) => ActionChip(
                                label: Text(search),
                                onPressed: () {
                                  _searchController.text = search;
                                  setState(() => _searchQuery = search);
                                },
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ),
                ),
              // 연락처 리스트
              Expanded(
                child: filteredContacts.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 64,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              '검색 결과가 없습니다',
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: filteredContacts.length,
                        itemBuilder: (context, index) {
                          final contact = filteredContacts[index];
                          final isFavorite = favoriteIds.contains(contact.id);
                          return _ContactCard(
                            contact: contact,
                            isFavorite: isFavorite,
                            onFavoriteToggle: () {
                              ref
                                  .read(favoriteControllerProvider.notifier)
                                  .toggleFavorite(contact.id);
                            },
                            onTap: () => _showContactDetail(
                              context,
                              contact,
                              isFavorite,
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showContactDetail(
    BuildContext context,
    Contact contact,
    bool isFavorite,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => ContactDetailSheet(
        contact: contact,
        isFavorite: isFavorite,
        onOrganizationTap: () {
          Navigator.pop(context);
          setState(() => _selectedOrganization = contact.organizationId);
        },
        onFavoriteToggle: () {
          ref
              .read(favoriteControllerProvider.notifier)
              .toggleFavorite(contact.id);
          Navigator.pop(context);
        },
      ),
    );
  }
}

// 상태 색상
Color _getStatusColor(String status) {
  switch (status) {
    case 'online':
      return Colors.green;
    case 'busy':
      return Colors.red;
    case 'away':
      return Colors.orange;
    default:
      return Colors.grey;
  }
}

String _getStatusText(String status) {
  switch (status) {
    case 'online':
      return '온라인';
    case 'busy':
      return '바쁨';
    case 'away':
      return '자리비움';
    default:
      return '오프라인';
  }
}

// 개선된 연락처 카드
class _ContactCard extends StatelessWidget {
  const _ContactCard({
    required this.contact,
    required this.isFavorite,
    required this.onFavoriteToggle,
    required this.onTap,
  });

  final Contact contact;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // 아바타 + 상태 표시
              Stack(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.primaryContainer,
                    backgroundImage: contact.avatarUrl != null
                        ? NetworkImage(contact.avatarUrl!)
                        : null,
                    child: contact.avatarUrl == null
                        ? Text(
                            (contact.username ?? 'U').substring(0, 1),
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(
                                context,
                              ).colorScheme.onPrimaryContainer,
                            ),
                          )
                        : null,
                  ),
                  // 상태 뱃지
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: _getStatusColor(contact.status),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              // 정보
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          contact.username ?? '이름 없음',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 4),
                        // 즐겨찾기 버튼
                        GestureDetector(
                          onTap: onFavoriteToggle,
                          child: Icon(
                            isFavorite ? Icons.star : Icons.star_border,
                            color: isFavorite ? Colors.amber : Colors.grey,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${contact.department ?? ''} · ${contact.position ?? ''}',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Icon(
                          Icons.phone_android,
                          size: 12,
                          color: Colors.grey.shade500,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          contact.mobilePhone ?? '',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                          ),
                        ),
                        if (contact.officePhone != null) ...[
                          const SizedBox(width: 8),
                          Icon(
                            Icons.phone,
                            size: 12,
                            color: Colors.grey.shade500,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '내선 ${contact.officePhone}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              // 액션 버튼들
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.phone,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    onPressed: () async {
                      final phone = contact.mobilePhone;
                      if (phone != null && phone.isNotEmpty) {
                        final uri = Uri.parse('tel:$phone');
                        if (await canLaunchUrl(uri)) {
                          await launchUrl(uri);
                        }
                      }
                    },
                    tooltip: '전화',
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.email,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    onPressed: () async {
                      final phone = contact.mobilePhone;
                      if (phone != null && phone.isNotEmpty) {
                        final uri = Uri.parse('sms:$phone');
                        if (await canLaunchUrl(uri)) {
                          await launchUrl(uri);
                        }
                      }
                    },
                    tooltip: '문자',
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.alternate_email,
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                    onPressed: () {
                      // TODO: 이메일 화면 완성 후 구현
                    },
                    tooltip: '이메일',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 연락처 상세 시트
class ContactDetailSheet extends StatelessWidget {
  const ContactDetailSheet({
    super.key,
    required this.contact,
    required this.isFavorite,
    required this.onOrganizationTap,
    required this.onFavoriteToggle,
  });

  final Contact contact;
  final bool isFavorite;
  final VoidCallback onOrganizationTap;
  final VoidCallback onFavoriteToggle;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) => SingleChildScrollView(
        controller: scrollController,
        child: Column(
          children: [
            // 핸들
            Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // 프로필 헤더
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // 아바타 + 상태
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Theme.of(
                          context,
                        ).colorScheme.primaryContainer,
                        backgroundImage: contact.avatarUrl != null
                            ? NetworkImage(contact.avatarUrl!)
                            : null,
                        child: contact.avatarUrl == null
                            ? Text(
                                (contact.username ?? 'U').substring(0, 1),
                                style: TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onPrimaryContainer,
                                ),
                              )
                            : null,
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _getStatusColor(contact.status),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            _getStatusText(contact.status),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // 이름 + 즐겨찾기
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        contact.username ?? '이름 없음',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: Icon(
                          isFavorite ? Icons.star : Icons.star_border,
                          color: isFavorite ? Colors.amber : Colors.grey,
                        ),
                        onPressed: onFavoriteToggle,
                      ),
                    ],
                  ),
                  // 조직 (클릭 가능)
                  TextButton.icon(
                    onPressed: onOrganizationTap,
                    icon: const Icon(Icons.corporate_fare, size: 16),
                    label: Text(
                      '${contact.department ?? ''} · ${contact.position ?? ''}',
                    ),
                  ),
                ],
              ),
            ),
            // 빠른 액션 버튼
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _ActionButton(
                    icon: Icons.phone,
                    label: '전화',
                    color: Colors.green,
                    onTap: () {},
                  ),
                  _ActionButton(
                    icon: Icons.email,
                    label: '메시지',
                    color: Colors.blue,
                    onTap: () {},
                  ),
                  _ActionButton(
                    icon: Icons.alternate_email,
                    label: '이메일',
                    color: Colors.orange,
                    onTap: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Divider(),
            // 상세 정보
            if (contact.mobilePhone != null)
              _DetailTile(
                icon: Icons.phone_android,
                label: '휴대폰',
                value: contact.mobilePhone!,
              ),
            if (contact.officePhone != null)
              _DetailTile(
                icon: Icons.phone,
                label: '내선번호',
                value: contact.officePhone!,
              ),
            _DetailTile(icon: Icons.email, label: '이메일', value: contact.email),
            if (contact.department != null)
              _DetailTile(
                icon: Icons.business,
                label: '소속',
                value: contact.department!,
                onTap: onOrganizationTap,
              ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(color: color, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailTile extends StatelessWidget {
  const _DetailTile({
    required this.icon,
    required this.label,
    required this.value,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final String value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey),
      title: Text(
        label,
        style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
      ),
      subtitle: Text(value, style: const TextStyle(fontSize: 16)),
      trailing: onTap != null ? const Icon(Icons.chevron_right) : null,
      onTap: onTap,
    );
  }
}

/// 펼치기/접기 가능한 조직 타일
/// 접힌 상태에서 클릭 → 펼치기
/// 펼쳐진 상태에서 클릭 → 선택
class _ExpandableOrgTile extends StatefulWidget {
  const _ExpandableOrgTile({
    required this.division,
    required this.childOrgs,
    required this.isSelected,
    required this.initiallyExpanded,
    required this.contactCount,
    required this.selectedOrganization,
    required this.onSelectDivision,
    required this.onSelectTeam,
    required this.getContactCount,
  });

  final Organization division;
  final List<Organization> childOrgs;
  final bool isSelected;
  final bool initiallyExpanded;
  final int contactCount;
  final String? selectedOrganization;
  final VoidCallback onSelectDivision;
  final void Function(String teamId) onSelectTeam;
  final int Function(String? orgId) getContactCount;

  @override
  State<_ExpandableOrgTile> createState() => _ExpandableOrgTileState();
}

class _ExpandableOrgTileState extends State<_ExpandableOrgTile> {
  late bool _isExpanded;
  final ExpansibleController _controller = ExpansibleController();

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        controller: _controller,
        key: ValueKey(widget.division.id),
        initiallyExpanded: widget.initiallyExpanded,
        onExpansionChanged: (expanded) {
          setState(() => _isExpanded = expanded);
        },
        leading: GestureDetector(
          onTap: _handleTap,
          child: CircleAvatar(
            backgroundColor: widget.isSelected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.surfaceContainerHighest,
            child: Icon(
              Icons.corporate_fare,
              color: widget.isSelected ? Colors.white : null,
              size: 20,
            ),
          ),
        ),
        title: GestureDetector(
          onTap: _handleTap,
          child: Text(
            '${widget.division.name} (${widget.contactCount})',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: widget.isSelected
                  ? Theme.of(context).colorScheme.primary
                  : null,
            ),
          ),
        ),
        trailing: widget.isSelected
            ? Icon(
                Icons.check_circle,
                color: Theme.of(context).colorScheme.primary,
              )
            : Icon(
                _isExpanded ? Icons.expand_less : Icons.expand_more,
                color: Colors.grey,
              ),
        children: widget.childOrgs.map((team) {
          final isTeamSelected = team.id == widget.selectedOrganization;
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: isTeamSelected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.surfaceContainerHighest,
              child: Icon(
                Icons.group,
                color: isTeamSelected ? Colors.white : null,
                size: 20,
              ),
            ),
            title: Text(
              '${team.name} (${widget.getContactCount(team.id)})',
              style: TextStyle(
                color: isTeamSelected
                    ? Theme.of(context).colorScheme.primary
                    : null,
              ),
            ),
            trailing: isTeamSelected
                ? Icon(
                    Icons.check_circle,
                    color: Theme.of(context).colorScheme.primary,
                  )
                : null,
            contentPadding: const EdgeInsets.only(left: 40, right: 16),
            onTap: () => widget.onSelectTeam(team.id),
          );
        }).toList(),
      ),
    );
  }

  void _handleTap() {
    if (_isExpanded) {
      // 펼쳐진 상태에서 클릭 → 본부 선택
      widget.onSelectDivision();
    } else {
      // 접힌 상태에서 클릭 → 펼치기
      _controller.expand();
    }
  }
}
