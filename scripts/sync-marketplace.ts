#!/usr/bin/env node

import { readFileSync, writeFileSync, readdirSync, statSync } from 'fs';
import { resolve, dirname, join } from 'path';
import { fileURLToPath } from 'url';

const __dirname = dirname(fileURLToPath(import.meta.url));
const projectRoot = resolve(__dirname, '..');

interface PluginManifest {
  name: string;
  version: string;
  description: string;
  author: {
    name: string;
    email: string;
  };
  homepage?: string;
  repository?: string;
  license?: string;
  keywords?: string[];
  category?: string;
}

function validatePlugin(
  plugin: PluginManifest,
  dirName: string
): string[] {
  const errors: string[] = [];

  // Validate name matches directory
  if (plugin.name !== dirName) {
    errors.push(
      `Plugin name "${plugin.name}" doesn't match directory "${dirName}"`
    );
  }

  // Validate kebab-case
  if (!/^[a-z][a-z0-9-]*$/.test(plugin.name)) {
    errors.push(`Plugin name "${plugin.name}" is not kebab-case`);
  }

  // Validate semver
  if (!/^\d+\.\d+\.\d+/.test(plugin.version)) {
    errors.push(
      `Plugin "${plugin.name}" version "${plugin.version}" is not valid semver`
    );
  }

  // Validate required fields
  if (!plugin.description?.trim()) {
    errors.push(`Plugin "${plugin.name}" missing description`);
  }

  if (!plugin.author?.name?.trim()) {
    errors.push(`Plugin "${plugin.name}" missing author.name`);
  }

  if (!plugin.author?.email?.trim()) {
    errors.push(`Plugin "${plugin.name}" missing author.email`);
  }

  return errors;
}

function discoverPlugins() {
  const pluginsDir = resolve(projectRoot, 'plugins');
  const plugins = [];

  try {
    const entries = readdirSync(pluginsDir);

    for (const entry of entries) {
      const pluginPath = join(pluginsDir, entry);
      const pluginJsonPath = join(pluginPath, '.claude-plugin/plugin.json');

      if (!statSync(pluginPath).isDirectory()) continue;

      try {
        const pluginJson: PluginManifest = JSON.parse(
          readFileSync(pluginJsonPath, 'utf-8')
        );

        // Validate plugin
        const validationErrors = validatePlugin(pluginJson, entry);
        if (validationErrors.length > 0) {
          console.error(`\n❌ Validation errors for ${entry}:`);
          validationErrors.forEach((err) => console.error(`  - ${err}`));
          process.exit(1);
        }

        const plugin: any = {
          name: pluginJson.name,
          source: `./plugins/${entry}`,
          description: pluginJson.description,
          version: pluginJson.version,
          author: pluginJson.author,
        };

        if (pluginJson.homepage) plugin.homepage = pluginJson.homepage;
        if (pluginJson.repository) plugin.repository = pluginJson.repository;
        if (pluginJson.license) plugin.license = pluginJson.license;
        if (pluginJson.keywords) plugin.keywords = pluginJson.keywords;
        if (pluginJson.category) plugin.category = pluginJson.category;

        plugins.push(plugin);
        console.log(`✓ Discovered plugin: ${pluginJson.name}`);
      } catch (err) {
        console.warn(`⚠ Skipping ${entry}: no valid plugin.json`);
      }
    }
  } catch (err) {
    const message = err instanceof Error ? err.message : String(err);
    console.error(`Failed to read plugins directory:`, message);
  }

  return plugins;
}

function syncMarketplace() {
  console.log('🔄 Syncing marketplace...\n');

  const marketplacePath = resolve(
    projectRoot,
    '.claude-plugin/marketplace.json'
  );
  const marketplace = JSON.parse(readFileSync(marketplacePath, 'utf-8'));

  // Discover all plugins in plugins/ directory
  marketplace.plugins = discoverPlugins();

  writeFileSync(marketplacePath, JSON.stringify(marketplace, null, 2) + '\n');
  console.log(
    `\n✅ Marketplace synced successfully with ${marketplace.plugins.length} plugins`
  );
}

syncMarketplace();
