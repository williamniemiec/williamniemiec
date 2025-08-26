import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../auth/providers/auth_provider.dart';
import '../../location/providers/location_provider.dart';

class AddressSelector extends StatelessWidget {
  const AddressSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthProvider, LocationProvider>(
      builder: (context, authProvider, locationProvider, child) {
        final currentUser = authProvider.currentUser;
        final currentAddress = locationProvider.currentAddress;
        
        // Get the default address or current location
        final displayAddress = currentUser?.addresses
            .where((addr) => addr.isDefault)
            .firstOrNull ?? currentAddress;

        return GestureDetector(
          onTap: () => _showAddressBottomSheet(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppTheme.borderGrey),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.location_on,
                  color: AppTheme.primaryRed,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Entregar em',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.textGrey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        displayAddress?.label ?? 'Selecionar endereço',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textDark,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (displayAddress != null)
                        Text(
                          '${displayAddress.street}, ${displayAddress.number}',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppTheme.textGrey,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down,
                  color: AppTheme.textGrey,
                  size: 20,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showAddressBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AddressBottomSheet(),
    );
  }
}

class AddressBottomSheet extends StatelessWidget {
  const AddressBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppTheme.borderGrey,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Text(
                  'Endereços',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),

          // Current Location Option
          Consumer<LocationProvider>(
            builder: (context, locationProvider, child) {
              return ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryRed.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.my_location,
                    color: AppTheme.primaryRed,
                    size: 20,
                  ),
                ),
                title: const Text('Usar localização atual'),
                subtitle: locationProvider.currentAddress != null
                    ? Text(locationProvider.currentAddress!.fullAddress)
                    : const Text('Obter localização atual'),
                onTap: () async {
                  if (locationProvider.currentAddress == null) {
                    await locationProvider.getCurrentLocation();
                  }
                  if (locationProvider.currentAddress != null) {
                    locationProvider.setCurrentAddress(locationProvider.currentAddress!);
                    Navigator.of(context).pop();
                  }
                },
              );
            },
          ),

          const Divider(),

          // Saved Addresses
          Expanded(
            child: Consumer<AuthProvider>(
              builder: (context, authProvider, child) {
                final addresses = authProvider.currentUser?.addresses ?? [];
                
                if (addresses.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.location_off,
                          size: 64,
                          color: AppTheme.textLight,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Nenhum endereço salvo',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppTheme.textGrey,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: addresses.length,
                  itemBuilder: (context, index) {
                    final address = addresses[index];
                    return ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: address.isDefault 
                              ? AppTheme.primaryRed.withOpacity(0.1)
                              : AppTheme.backgroundGrey,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          address.label.toLowerCase().contains('casa')
                              ? Icons.home
                              : address.label.toLowerCase().contains('trabalho')
                                  ? Icons.work
                                  : Icons.location_on,
                          color: address.isDefault 
                              ? AppTheme.primaryRed 
                              : AppTheme.textGrey,
                          size: 20,
                        ),
                      ),
                      title: Text(address.label),
                      subtitle: Text(address.fullAddress),
                      trailing: address.isDefault
                          ? Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryRed,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                'Padrão',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            )
                          : null,
                      onTap: () {
                        context.read<LocationProvider>().setCurrentAddress(address);
                        Navigator.of(context).pop();
                      },
                    );
                  },
                );
              },
            ),
          ),

          // Add Address Button
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).pop();
                  // Navigate to add address screen
                },
                icon: const Icon(Icons.add),
                label: const Text('Adicionar novo endereço'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}