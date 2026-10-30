import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/theme.dart';
import '../../config/constants.dart';
import '../../models/doctor_model.dart';
import '../../services/firestore_service.dart';
import '../../widgets/doctor_card.dart';
import 'doctor_detail_screen.dart';

class SearchDoctorsScreen extends ConsumerStatefulWidget {
  const SearchDoctorsScreen({super.key});

  @override
  ConsumerState<SearchDoctorsScreen> createState() =>
      _SearchDoctorsScreenState();
}

class _SearchDoctorsScreenState extends ConsumerState<SearchDoctorsScreen> {
  final _searchController = TextEditingController();
  final _firestoreService = FirestoreService();
  String? _selectedSpecialization;
  List<DoctorModel> _doctors = [];
  List<DoctorModel> _filteredDoctors = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDoctors();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadDoctors() async {
    setState(() => _isLoading = true);
    try {
      _doctors = await _firestoreService.getApprovedDoctors();
      _filteredDoctors = List.from(_doctors);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading doctors: $e')),
        );
      }
    }
    if (mounted) setState(() => _isLoading = false);
  }

  void _applyFilters() {
    setState(() {
      _filteredDoctors = _doctors.where((doctor) {
        // Search filter
        final searchMatch = _searchController.text.isEmpty ||
            doctor.name
                .toLowerCase()
                .contains(_searchController.text.toLowerCase()) ||
            doctor.specialization
                .toLowerCase()
                .contains(_searchController.text.toLowerCase());

        // Specialization filter
        final specMatch = _selectedSpecialization == null ||
            _selectedSpecialization == 'All' ||
            doctor.specialization == _selectedSpecialization;

        return searchMatch && specMatch;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find a Doctor'),
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: TextField(
              controller: _searchController,
              onChanged: (_) => _applyFilters(),
              decoration: InputDecoration(
                hintText: 'Search by name or specialization...',
                prefixIcon: const Icon(Icons.search, size: 20),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        onPressed: () {
                          _searchController.clear();
                          _applyFilters();
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: AppColors.surfaceVariant,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
            ),
          ),

          // Specialization filter chips
          SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _FilterChip(
                  label: 'All',
                  isSelected: _selectedSpecialization == null ||
                      _selectedSpecialization == 'All',
                  onTap: () {
                    setState(() => _selectedSpecialization = null);
                    _applyFilters();
                  },
                ),
                ...AppConstants.specializations.map((spec) => _FilterChip(
                      label: spec,
                      isSelected: _selectedSpecialization == spec,
                      onTap: () {
                        setState(() => _selectedSpecialization = spec);
                        _applyFilters();
                      },
                    )),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Results count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Text(
                  '${_filteredDoctors.length} doctor${_filteredDoctors.length != 1 ? 's' : ''} found',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                ),
                const Spacer(),
                // Sort option
                PopupMenuButton<String>(
                  icon: const Icon(Icons.sort, size: 20),
                  onSelected: (value) {
                    setState(() {
                      switch (value) {
                        case 'rating':
                          _filteredDoctors
                              .sort((a, b) => b.averageRating.compareTo(a.averageRating));
                          break;
                        case 'experience':
                          _filteredDoctors.sort(
                              (a, b) => b.experienceYears.compareTo(a.experienceYears));
                          break;
                        case 'fee_low':
                          _filteredDoctors.sort(
                              (a, b) => a.consultationFee.compareTo(b.consultationFee));
                          break;
                        case 'fee_high':
                          _filteredDoctors.sort(
                              (a, b) => b.consultationFee.compareTo(a.consultationFee));
                          break;
                      }
                    });
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(value: 'rating', child: Text('Rating (High → Low)')),
                    const PopupMenuItem(value: 'experience', child: Text('Experience')),
                    const PopupMenuItem(value: 'fee_low', child: Text('Fee (Low → High)')),
                    const PopupMenuItem(value: 'fee_high', child: Text('Fee (High → Low)')),
                  ],
                ),
              ],
            ),
          ),

          // Doctors list
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredDoctors.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 64,
                              color: AppColors.textHint,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No doctors found',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Try changing your search or filter',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: _loadDoctors,
                        child: ListView.builder(
                          padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                          itemCount: _filteredDoctors.length,
                          itemBuilder: (context, index) {
                            final doctor = _filteredDoctors[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: DoctorCard(
                                doctor: doctor,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => DoctorDetailScreen(
                                        doctor: doctor,
                                      ),
                                    ),
                                  );
                                },
                                onBookNow: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => DoctorDetailScreen(
                                        doctor: doctor,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.textPrimary,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        selected: isSelected,
        selectedColor: AppColors.primary,
        backgroundColor: AppColors.surfaceVariant,
        checkmarkColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        side: BorderSide.none,
        onSelected: (_) => onTap(),
      ),
    );
  }
}
