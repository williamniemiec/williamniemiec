import 'package:flutter/material.dart';
import 'business_profile_screen.dart';
import 'catalog_screen.dart';
import 'messaging_settings_screen.dart';
import 'labels_screen.dart';

class ToolsScreen extends StatelessWidget {
  const ToolsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Business Tools'),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {
              _showHelpDialog(context);
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionHeader('Business Setup'),
          _buildToolItem(
            context,
            icon: Icons.business,
            title: 'Business Profile',
            subtitle: 'Manage your business information',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const BusinessProfileScreen(),
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildSectionHeader('Products & Services'),
          _buildToolItem(
            context,
            icon: Icons.shopping_bag,
            title: 'Catalog',
            subtitle: 'Manage your products and services',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CatalogScreen(),
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildSectionHeader('Customer Communication'),
          _buildToolItem(
            context,
            icon: Icons.message,
            title: 'Messaging',
            subtitle: 'Greeting, away messages, and quick replies',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const MessagingSettingsScreen(),
              ),
            ),
          ),
          _buildToolItem(
            context,
            icon: Icons.label,
            title: 'Labels',
            subtitle: 'Organize your chats with labels',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const LabelsScreen(),
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildSectionHeader('Marketing & Growth'),
          _buildToolItem(
            context,
            icon: Icons.campaign,
            title: 'Advertise',
            subtitle: 'Create ads on Facebook and Instagram',
            onTap: () => _showAdvertiseDialog(context),
          ),
          _buildToolItem(
            context,
            icon: Icons.qr_code,
            title: 'QR Code',
            subtitle: 'Share your business contact',
            onTap: () => _showQRCodeDialog(context),
          ),
          _buildToolItem(
            context,
            icon: Icons.link,
            title: 'Short Link',
            subtitle: 'Create a link to start chats',
            onTap: () => _showShortLinkDialog(context),
          ),
          const SizedBox(height: 16),
          _buildSectionHeader('Analytics & Insights'),
          _buildToolItem(
            context,
            icon: Icons.analytics,
            title: 'Message Statistics',
            subtitle: 'View your messaging insights',
            onTap: () => _showStatisticsDialog(context),
          ),
          const SizedBox(height: 16),
          _buildSectionHeader('Settings'),
          _buildToolItem(
            context,
            icon: Icons.settings,
            title: 'Business Settings',
            subtitle: 'Privacy, notifications, and more',
            onTap: () => _showSettingsDialog(context),
          ),
          _buildToolItem(
            context,
            icon: Icons.info_outline,
            title: 'About',
            subtitle: 'App version and information',
            onTap: () => _showAboutDialog(context),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildToolItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: Theme.of(context).primaryColor,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Help & Support'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('WhatsApp Business Help Center'),
            SizedBox(height: 8),
            Text('• Getting started guide'),
            Text('• Feature tutorials'),
            Text('• Best practices'),
            Text('• Contact support'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Open help center
            },
            child: const Text('Visit Help Center'),
          ),
        ],
      ),
    );
  }

  void _showAdvertiseDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Advertise Your Business'),
        content: const Text(
          'Create ads on Facebook and Instagram that click to WhatsApp. '
          'Reach more customers and grow your business.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Open advertising setup
            },
            child: const Text('Get Started'),
          ),
        ],
      ),
    );
  }

  void _showQRCodeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('QR Code'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Icon(
                  Icons.qr_code,
                  size: 100,
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Customers can scan this QR code to start a chat with your business.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Share QR code
              Navigator.pop(context);
            },
            child: const Text('Share'),
          ),
        ],
      ),
    );
  }

  void _showShortLinkDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Short Link'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Your business link:'),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'https://wa.me/1234567890',
                style: TextStyle(fontFamily: 'monospace'),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Share this link so customers can easily start a chat with your business.',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Copy/share link
              Navigator.pop(context);
            },
            child: const Text('Share Link'),
          ),
        ],
      ),
    );
  }

  void _showStatisticsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Message Statistics'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Messages sent: 156'),
            Text('Messages received: 89'),
            Text('Messages delivered: 142'),
            Text('Messages read: 134'),
            SizedBox(height: 16),
            Text('This week vs last week:'),
            Text('↗️ +23% messages sent'),
            Text('↗️ +15% messages received'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Business Settings'),
        content: const Text('Business settings will be implemented here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About WhatsApp Business'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Version: 1.0.0'),
            SizedBox(height: 8),
            Text('WhatsApp Business helps small and medium businesses communicate with customers easily.'),
            SizedBox(height: 16),
            Text('Features:'),
            Text('• Business profile'),
            Text('• Product catalog'),
            Text('• Automated messages'),
            Text('• Customer labels'),
            Text('• Message statistics'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}