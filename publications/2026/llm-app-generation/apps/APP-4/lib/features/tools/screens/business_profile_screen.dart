import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/business_profile_provider.dart';
import '../../../shared/models/business_profile.dart';
import '../../../core/constants/app_constants.dart';

class BusinessProfileScreen extends StatefulWidget {
  const BusinessProfileScreen({super.key});

  @override
  State<BusinessProfileScreen> createState() => _BusinessProfileScreenState();
}

class _BusinessProfileScreenState extends State<BusinessProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BusinessProfileProvider>().loadBusinessProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Business Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              _showEditDialog();
            },
          ),
        ],
      ),
      body: Consumer<BusinessProfileProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.businessProfile == null) {
            return const Center(
              child: Text('No business profile found'),
            );
          }

          final profile = provider.businessProfile!;
          
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Header
                Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Theme.of(context).primaryColor,
                        backgroundImage: profile.logoUrl != null
                            ? NetworkImage(profile.logoUrl!)
                            : null,
                        child: profile.logoUrl == null
                            ? Text(
                                profile.businessName[0].toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 32,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            : null,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        profile.businessName,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (profile.isVerified)
                        const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.verified, color: Colors.blue, size: 16),
                            SizedBox(width: 4),
                            Text('Verified Business'),
                          ],
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                
                // Business Information
                _buildInfoSection('Business Information', [
                  _buildInfoItem('Category', profile.category ?? 'Not specified'),
                  _buildInfoItem('Description', profile.description ?? 'No description'),
                  _buildInfoItem('Email', profile.email ?? 'Not specified'),
                  _buildInfoItem('Website', profile.website ?? 'Not specified'),
                  _buildInfoItem('Address', profile.address ?? 'Not specified'),
                ]),
                
                const SizedBox(height: 24),
                
                // Business Hours
                if (profile.businessHours != null)
                  _buildBusinessHours(profile.businessHours!),
                
                const SizedBox(height: 24),
                
                // Profile Stats
                _buildInfoSection('Profile Stats', [
                  _buildInfoItem('Created', _formatDate(profile.createdAt)),
                  _buildInfoItem('Last Updated', _formatDate(profile.updatedAt)),
                ]),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: children,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  Widget _buildBusinessHours(BusinessHours businessHours) {
    return _buildInfoSection('Business Hours', [
      ...businessHours.schedule.entries.map((entry) {
        final day = entry.key;
        final hours = entry.value;
        final dayName = day[0].toUpperCase() + day.substring(1);
        
        String hoursText;
        if (hours.isOpen && hours.openTime != null && hours.closeTime != null) {
          hoursText = '${hours.openTime} - ${hours.closeTime}';
        } else {
          hoursText = 'Closed';
        }
        
        return _buildInfoItem(dayName, hoursText);
      }).toList(),
    ]);
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showEditDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Profile'),
        content: const Text('Profile editing feature will be implemented here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Navigate to edit screen
            },
            child: const Text('Edit'),
          ),
        ],
      ),
    );
  }
}